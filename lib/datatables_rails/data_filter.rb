module DatatablesRails
  class DataFilter
    def initialize(source_class_name, request_params, options, additional_filters, additional_columns)
      @request_params = request_params
      @additional_filters = additional_filters
      @options = options
      @source_class_name = source_class_name
      @additional_columns = additional_columns
    end

    def get_filtered_data(source)
      source = filter_by_custom_filters_if_exist(source)
      source = filter_by_searched_text_if_exists(source)
      source = @options.filter_module.sort_data(source, find_sort_column_name, @request_params.sort_direction)
      source = @options.filter_module.page_data(source, @request_params.page, @request_params.per_page)

      source
    end

    def get_source_count_after_filter
      @records_count_after_filter
    end

    private 

      def filter_by_custom_filters_if_exist(source)
        @additional_filters.try_call(@source_class_name, source, @request_params) || source
      end

      def filter_by_searched_text_if_exists(source)
        if @request_params.search_text.present?
          source = @options.filter_module.search_data(source, @options.search_columns, @request_params.search_text)
        end

        @records_count_after_filter = source.size
        source
      end

      def find_sort_column_name
        index = @request_params.sort_column_index
        index -= 1 if @additional_columns.items[:first] && index != 0
        @options.columns[index].to_s
      end
  end
end