module DatatablesRails
  module ViewHelper
    def datatable_tag(class_type, options = {})
      config = Settings.send(options[:settings_name] || class_type.name.underscore).dup
      config = merge_options_for_parameter(config, options)
      config = merge_default_options(class_type, config)

      render "datatables_rails/datatable", class_type: class_type, options: OpenStruct.new(config)
    end

    private

      def merge_options_for_parameter(config, options)
        options.each do |key, value|
          config[key] = value;
        end

        config
      end

      def merge_default_options(class_type, config)
        default_options = get_default_options(class_type)
        default_options.each do |key, value|
          config[key] = value unless config[key]
        end

        config
      end

      def get_default_options(class_type)
        {
          source_path: send("#{class_type.name.underscore.pluralize}_path", { :format => :json, :only_path => false }),
          sorting_column: 0,
          sorting_type: "asc",
          columns_without_sorting: []
        }
      end
  end
end