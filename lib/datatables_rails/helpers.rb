module DatatablesRails
  module Helpers

    IGNORED_COLUMNS = %w(id created_at updated_at)
    TEMPLATE_PATH = 'datatables_rails'

    def table_tag(class_type, options = {}, *columns)
      config = Settings.send(options[:settings_name] || class_type.name.underscore).dup
      config[:columns] = columns if columns.any?

      options.each do |key, value|
        config[key] = value;
      end

      render "#{TEMPLATE_PATH}/table_tag", class_type: class_type, columns: config[:columns], options: config
    end

    def table_standard_buttons_tag(element, render_method = "render")
      edit_path ||= send("edit_#{element.class.name.underscore}_path", element)

      send(render_method, partial: "#{TEMPLATE_PATH}/table_standard_buttons_tag", formats: [:html],
        locals: { element: element, edit_path: edit_path })
    end
  end
end