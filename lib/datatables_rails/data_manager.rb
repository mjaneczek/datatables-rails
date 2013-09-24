require 'ostruct'

module DatatablesRails
  class DataManager
    attr_accessor :templates, :additional_filters, :additional_columns

    def initialize(params)
      @params = RequestParameters.new(params)
      initialize_default_services
    end

    def generate_json(source, parameters = {})
      @source = source
      return empty_answer unless detect_class_name

      load_options_from_parameter_or_settings_file(parameters)
      filter_data
      
      return JsonGenerator.generate(@params.echo_number, format_data,
        @source.count, @records_count_after_filter)
    end

    def filter_data
      detect_or_set_default_filter_module
      data_filter = DataFilter.new(detect_class_name, @params, @options, additional_filters, additional_columns)
      @source = data_filter.get_filtered_data(@source)
      @records_count_after_filter = data_filter.get_source_count_after_filter
    end

    def format_data
      @source.map do |item|
        row = []
        row = push_unless_nil(row, @additional_columns.try_call(:first, item))

        row += @options.columns.map do |column|
          @templates.try_call(column, item) || item.try(column).try(:to_s)
        end 

        row = push_unless_nil(row, @additional_columns.try_call(:last, item))
      end
    end

  private
    def initialize_default_services
      @templates = CustomizeService.new
      @additional_filters = CustomizeService.new
      @additional_columns = CustomizeService.new
    end

    def load_default_options(settings_name)
      settings_name ||= @source_class_name
      @options = OpenStruct.new(Settings.send(settings_name))
    end

    def load_options_from_parameter_or_settings_file(parameters)
      @options = parameters[:options] &&= OpenStruct.new(parameters[:options])
      load_default_options(parameters[:settings_name]) unless @options
    end

    def detect_or_set_default_filter_module
      if @options.filter_module
        @options.filter_module = eval(@options.filter_module)
      else
        @options.filter_module = ActiveRecordSource
      end
    end

    def push_unless_nil(array, item)
      array << item if item
      array
    end

    def empty_answer
      JsonGenerator.generate(@params.echo_number)
    end

    def detect_class_name
      @source_class_name = @source.first.try(:class).try(:name).try(:underscore)
    end
  end
end