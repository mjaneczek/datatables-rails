module CommonViews
  module Helpers

    IGNORED_COLUMNS = %w(id created_at updated_at)
    TEMPLATE_PATH = 'common_views'

    # def full_title(page_title)
    #   t("title") + (" | #{page_title}" unless page_title.blank?).to_s
    # end

    def form_standard_buttons_tag(f, controller)
      render "#{TEMPLATE_PATH}/form_standard_buttons_tag", f: f, controller: controller
    end

    def table_standard_buttons_tag(element, render_method = "render")
      edit_path ||= send("edit_#{element.class.name.underscore}_path", element)

      send(render_method, partial: 'common-views/table_standard_buttons_tag', formats: [:html],
        locals: { element: element, edit_path: edit_path })
    end

    def create_button_for(type, title = 'Dodaj')
      render "#{TEMPLATE_PATH}/create_button_for", type: type, title: title if can? :create, type
    end

    def simple_table_for(items)
      render "#{TEMPLATE_PATH}/simple_table_for", items: items
    end

    def table_tag(class_type, options = {}, *columns)
      config = Settings.send(options[:settings_name] || class_type.name.underscore).dup
      config[:columns] = columns if columns.any?

      options.each do |key, value|
        config[key] = value;
      end

      render "#{TEMPLATE_PATH}/table_tag", class_type: class_type, columns: config[:columns], options: config
    end

    def import_tag(path, label)
      render "#{TEMPLATE_PATH}/file_input_tag", path: path, label: label
    end

    def docket_tag(text, render_method = "render")
      send(render_method, partial: "#{TEMPLATE_PATH}/docket_tag", formats: [:html],
        locals: { text: text })
    end

  end
end