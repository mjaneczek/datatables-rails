module DatatablesRails
  class DataManager
    delegate :params, to: :@view

    attr_accessor :last_column_template, :first_column_template

    def initialize(view)
      @view = view
      @custom_templates = {}
      @custom_filters = {}
    end

    def register_custom_template(symbol, &block)
      @custom_templates[symbol] = block
    end

    def register_custom_filter(symbol, &block)
      @custom_filters[symbol] = block
    end

    def generate_json(source, options = nil, filter_module = ActiveRecordAjaxDatatable, settings_name = nil)
      return JsonGenerator.generate(params[:sEcho].to_i) unless detect_class_name

      unless options
        settings_name ||= @source_class_name

        options = TableParameters.new(Settings.send(settings_name).try(:[], "columns"),
          Settings.send(settings_name).try(:[], "search_columns"))
      end

      filtered_records_count, data = filter_data(source, options, filter_module).values

      return JsonGenerator.generate(params[:sEcho].to_i, format_data(data, options),
        get_source_count(source), filtered_records_count)
    end

    def filter_data(source, options, filter_module = ActiveRecordAjaxDatatable)
      (source = @custom_filters[@source_class_name].call(source, params)) if @custom_filters[@source_class_name]
      (source = filter_module.search_data(source, options.filter_column, params[:sSearch])) if params[:sSearch].present?
      total_display_records = get_source_count(source)
      source = filter_module.sort_data(source, find_sort_column_name(options.columns), sort_direction)
      source = filter_module.page_data(source, page, per_page)

      return { total_display_records: total_display_records, data: source }
    end

    def format_data(source, options)
      source.map do |item|
        row = []

        first_column = first_column_template.call(item) if first_column_template
        row << first_column if first_column
        
        row += options.columns.map do |column|
          next @custom_templates[column].call(item) if @custom_templates[column]
          item.try(column).try(:to_s)
        end 

        row << last_column_template.call(item) if last_column_template
      end
    end

  private

    def page
      params[:iDisplayStart].to_i/per_page + 1
    end

    def per_page
      params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
    end

    def find_sort_column_name(columns)
      index = params[:iSortCol_0].to_i
      index -= 1 if first_column_template && index != 0
      columns[index].to_s
    end

    def sort_direction
      params[:sSortDir_0] == "desc" ? "desc" : "asc"
    end

    def get_source_count(source)
      source.count.try(:length) || source.count
    end

    def detect_class_name(source)
      @source_class_name = source.first.try(:class).try(:name).try(:underscore)
    end

  end
end