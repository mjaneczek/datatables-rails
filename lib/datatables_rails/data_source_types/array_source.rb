module DatatablesRails
  class ArraySource
    class << self
      def sort_data(source, sort_column, sort_direction)
        source.sort! {|a, b| a.send(sort_column).to_s <=> b.send(sort_column).to_s }
        (source.reverse! if sort_direction == "desc") || source
      end

      def page_data(source, page, per_page)
        source[(page - 1) * per_page..(page * per_page - 1)]
      end

      def search_data(source, filtered_columns, search_text)
        source.select do |model|
          filtered_columns.any? do |column|
            model.send(column).to_s.downcase.include? search_text.downcase 
          end
        end
      end
    end
  end
end