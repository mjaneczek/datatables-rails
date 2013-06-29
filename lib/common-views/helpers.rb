module CommonViews
  module Helpers
    def self.included(klass)
      klass.class_eval do
        # helper_method :full_title,
        #               :flash_to_bootstrap,
        #               :form_standard_buttons_tag,
        #               :table_standard_buttons_tag,
        #               :simple_table_for,
        #               :table_tag

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
          content_tag :div, class: 'form-actions' do
            concat link_to('Anuluj', controller, class: 'btn')
            concat ' '
            concat f.button(:submit, class: 'btn-success')
          end
        end

        def table_standard_buttons_tag(element)
          content_tag :span, class: 'pull-right' do
            concat link_to('Edytuj', send("edit_#{element.class.name.underscore}_path", element), class: 'btn btn-small') if can? :update, element
            concat ' '
            concat link_to('Usuń', element, method: :delete, data: { confirm: 'Czy jesteś pewien?' }, class: 'btn btn-small btn-danger') if can? :destroy, element
          end
        end

        def simple_table_for(items)
          content_tag :table, class: 'table' do
            concat content_tag(:thead, content_tag(:tr, content_tag(:th, 'Nazwa') + content_tag(:th)))

            items.each do |item|
              concat content_tag(:tr, content_tag(:td, item.name) + content_tag(:td, table_standard_buttons_tag(item)))
            end
          end
        end

        def table_tag(elements, *fields)
          return if elements.empty?

          if fields.empty?
            fields = elements.first.class.column_names.select { |column| IGNORED_COLUMNS.exclude? column }
          end

          ths = fields.map do |value|
            content_tag(:th, elements.first.class.human_attribute_name(value))
          end

          thead = content_tag :thead, content_tag(:tr, ths.reduce(:+))

          trs = elements.map do |element|
            tds = fields.map do |value|
              content_tag(:td, element.try(value))
            end

            content_tag(:tr, tds.reduce(:+) + content_tag(:td, table_standard_buttons_tag(element)))
          end

          tbody = content_tag :tbody, trs.reduce(:+)

          content_tag :table, thead.concat(tbody), class: "table"
        end
    end
  
  end
end