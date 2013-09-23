require 'ostruct'

module DatatablesRails
  class DataManager
    attr_accessor :templates, :filters, :additional_columns

    def initialize(params)
      @params = RequestParameters.new(params)
      initialize_default_services
    end

    def generate_json(source, parameters = {})
      @source = source
      return empty_answer unless detect_class_name

      @options = parameters[:options] &&= OpenStruct.new(parameters[:options])
      load_default_options(parameters[:settings_name]) unless @options

      filter_data

      return JsonGenerator.generate(@params.echo_number, format_data,
        get_source_count, @records_count_after_filter)
    end

    def filter_data
      detect_or_set_default_filter_module
      filter_by_custom_filters_if_exist
      filter_by_searched_text_if_exists
      @source = @options.filter_module.sort_data(@source, find_sort_column_name, @params.sort_direction)
      @source = @options.filter_module.page_data(@source, @params.page, @params.per_page)
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

    def filter_by_custom_filters_if_exist
      @source = @filters.try_call(@source_class_name, @source, @params) || @source
    end

    def filter_by_searched_text_if_exists
      if @params.search_text.present?
        @source = @options.filter_module.search_data(@source, @options.filter_column, @params.search_text)
      end

      @records_count_after_filter = get_source_count
    end

    def initialize_default_services
      @templates = CustomizeService.new
      @filters = CustomizeService.new
      @additional_columns = CustomizeService.new
    end

    def load_default_options(settings_name)
      settings_name ||= @source_class_name
      @options = OpenStruct.new(Settings.send(settings_name))
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

    def find_sort_column_name
      index = @params.sort_column_index
      index -= 1 if @additional_columns.items[:first] && index != 0
      @options.columns[index].to_s
    end

    def get_source_count
      @source.count.try(:length) || @source.count
    end

    def detect_class_name
      @source_class_name = @source.first.try(:class).try(:name).try(:underscore)
    end
  end
end