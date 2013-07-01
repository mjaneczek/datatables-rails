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

      def table_standard_buttons_tag(element)
        edit_path = send("edit_#{element.class.name.underscore}_path", element)
        
        render 'common-views/table_standard_buttons_tag', element: element, edit_path: edit_path
      end

      def create_button_for(type, title = 'Dodaj')
        render 'common-views/create_button_for', type: type, title: title if can? :create, type
      end

      def simple_table_for(items)
        render 'common-views/simple_table_for', items: items
      end

      def table_tag(elements, options = {}, *fields)
        render 'common-views/table_tag', model: elements, columns: fields, options: options
      end

    end

  end
end