module DatatablesRails
  class DataManager
    attr_accessor :templates, :filters, :additional_columns

    def initialize(params)
      @params = RequestParameters.new(params)
      initialize_default_services
    end

    def generate_json(source, options = nil, filter_module = ActiveRecordAjaxDatatable, settings_name = nil)
      return JsonGenerator.generate(@params.echo_number) unless detect_class_name

      unless options
        settings_name ||= @source_class_name

        options = TableParameters.new(Settings.send(settings_name).try(:[], "columns"),
          Settings.send(settings_name).try(:[], "search_columns"))
      end

      filtered_records_count, data = filter_data(source, options, filter_module).values

      return JsonGenerator.generate(@params.echo_number, format_data(data, options),
        get_source_count(source), filtered_records_count)
    end

    def filter_data(source, options, filter_module = ActiveRecordAjaxDatatable)
      source = @filters.try_call(@source_class_name, source, @params) || source
      (source = filter_module.search_data(source, options.filter_column, @params.search_text)) if @params.search_text.present?
      total_display_records = get_source_count(source)
      source = filter_module.sort_data(source, find_sort_column_name(options.columns), @params.sort_direction)
      source = filter_module.page_data(source, @params.page, @params.per_page)

      return { total_display_records: total_display_records, data: source }
    end

    def format_data(source, options)
      source.map do |item|
        row = []
        row = push_unless_nil(row, @additional_columns.try_call(:first, item))

        row += options.columns.map do |column|
          @templates.try_call(column, item) || item.try(column).try(:to_s)
        end 

        row = push_unless_nil(row, @additional_columns.try_call(:last, item))
      end
    end

  private

    def initialize_default_services
      @templates = CustomizeService.new
      @filters = CustomizeService.new
      @additional_columns = CustomizeService.new
    end

    def push_unless_nil(array, item)
      array << item if item
    end

    def find_sort_column_name(columns)
      index = @params.sort_column_index
      index -= 1 if first_column_template && index != 0
      columns[index].to_s
    end

    def get_source_count(source)
      source.count.try(:length) || source.count
    end

    def detect_class_name(source)
      @source_class_name = source.first.try(:class).try(:name).try(:underscore)
    end
  end
end