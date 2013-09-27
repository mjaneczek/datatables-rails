require 'ostruct'

module DatatablesRails
  class DataManager
    attr_accessor :templates, :additional_filters, :additional_columns
    delegate :filter_module, to: :@options

    def initialize(params)
      @params = RequestParameters.new(params)
      initialize_default_services
    end

    def generate_json(source, parameters = {})
      @source = source
      return empty_answer unless detect_class_name

      load_options_from_parameter_or_settings_file(parameters)

      return JsonGenerator.generate(@params.echo_number, filter_data && format_data,
        @records_count_before_filter, @records_count_after_filter)
    end

    def filter_data
      detect_or_set_default_filter_module
      @records_count_before_filter = filter_module.get_total_count(@source)
      data_filter = DataFilter.new(@source_class_name, @params, @options, additional_filters, additional_columns)
      @source = data_filter.get_filtered_data(@source)
      @records_count_after_filter = data_filter.get_source_count_after_filter
    end

    def format_data
      formatter = DataFormatter.new(@options, @templates, @additional_columns)
      formatter.format_data(@source)
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
      @options.filter_module = eval(@options.filter_module.to_s) || ActiveRecordSource
    end

    def empty_answer
      JsonGenerator.generate(@params.echo_number)
    end

    def detect_class_name
      @source_class_name = @source.first.try(:class).try(:name).try(:underscore)
    end
  end
end