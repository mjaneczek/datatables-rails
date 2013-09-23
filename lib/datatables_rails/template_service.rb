module DatatablesRails
  class TemplateService
    class << self
      @@templates = {}

      def register(column_name, &block)
        @@templates[column_name] = block
      end

      def try_get(column_name, item)
        @@templates[column_name].call(item) if @@templates[column_name]
      end
    end
  end
end