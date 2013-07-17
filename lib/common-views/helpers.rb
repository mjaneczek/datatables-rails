module CommonViews
  module Helpers

    def self.included(klass)
      klass.class_eval do
        include InstanceMethods
      end
    end

    module InstanceMethods

      IGNORED_COLUMNS = %w(id created_at updated_at)

      def full_title(page_title)
        base_title = t("title")
        if page_title.blank?
          base_title
        else
          "#{base_title} | #{page_title}"
        end
      end

      def flash_to_bootstrap(name)
        case name
          when :notice then "success"
          when :alert then "error"
          else name
        end
      end

      def form_standard_buttons_tag(f, controller)
        render 'common-views/form_standard_buttons_tag', f: f, controller: controller
      end

      def table_standard_buttons_tag(element, render_method = "render")
        edit_path ||= send("edit_#{element.class.name.underscore}_path", element)
        
        send(render_method, partial: 'common-views/table_standard_buttons_tag', formats: [:html],
          locals: { element: element, edit_path: edit_path })
      end

      def create_button_for(type, title = 'Dodaj')
        render 'common-views/create_button_for', type: type, title: title if can? :create, type
      end

      def simple_table_for(items)
        render 'common-views/simple_table_for', items: items
      end

      def table_tag(class_type, options = {}, *columns)
        config = Settings.send(options[:settings_name] || class_type.name.underscore).dup
        config[:columns] = columns if columns.any?
        
        options.each do |key, value|
          config[key] = value;
        end

        render 'common-views/table_tag', class_type: class_type, columns: config[:columns], options: config
      end

      def import_tag(path, label)
        render 'common-views/file_input_tag', path: path, label: label
      end

      def label_tag(text, render_method = "render")        
        send(render_method, partial: 'common-views/label_tag', formats: [:html],
          locals: { text: text })
      end

      def render_safe_js(path, options = {})
        render 'common-views/safe_js', path: path, options: options
      end

    end
  end
end