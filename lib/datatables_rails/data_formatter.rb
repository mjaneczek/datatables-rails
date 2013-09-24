module DatatablesRails
  class DataFormatter
    def initialize(options, templates, additional_columns)
      @options = options
      @templates = templates
      @additional_columns = additional_columns
    end

    def format_data(source)
      source.map do |item|
        row = []
        row = push_unless_nil(row, @additional_columns.try_call(:first, item))

        row += @options.columns.map do |column|
          @templates.try_call(column, item) || item.try(column).try(:to_s)
        end 

        row = push_unless_nil(row, @additional_columns.try_call(:last, item))
      end
    end
    
    private
      def push_unless_nil(array, item)
        array << item if item
        array
      end
  end
end