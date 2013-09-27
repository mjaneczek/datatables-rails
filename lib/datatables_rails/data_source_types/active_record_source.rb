module DatatablesRails
  class ActiveRecordSource
    class << self
      def sort_data(source, sort_column, sort_direction)
        source.order("#{sort_column} #{sort_direction}")
      end

      def page_data(source, page, per_page)
        source.page(page).per_page(per_page)
      end

      def search_data(source, filtered_columns, search_text)
        source.where(prepare_where_sql(filtered_columns, search_text))
      end

      def get_total_count(source)
        source.count.try(:length) || source.count
      end

      private
        def prepare_where_sql(filtered_columns, search_text)
          query = String.new

          filtered_columns.each_with_index do |column, index|
            query += ActiveRecord::Base.send(:sanitize_sql_array, ["CAST(#{column} AS TEXT) ilike '%s'", "%#{search_text}%"])
            query += " OR " if index < filtered_columns.length - 1
          end

          query
        end
    end
  end
end