require 'common-rails/application_responder'

module CommonRails
  class Base < ActionController::Base
    def self.inherit_resources(base)
      base.class_eval do
        self.responder = CommonRails::ApplicationResponder
  
        protect_from_forgery with: :exception
        respond_to :html, :json
        helper_method :full_title
        helper_method :flash_to_bootstrap
        helper_method :form_standard_buttons_tag
        helper_method :table_standard_buttons_tag
        helper_method :table_tag
        
        # # Add at least :html mime type
        # respond_to :html if self.mimes_for_respond_to.empty?
        # self.responder = InheritedResources::Responder
        # 
        # helper_method :resource, :collection, :resource_class, :association_chain,
        #               :resource_instance_name, :resource_collection_name,
        #               :resource_url, :resource_path,
        #               :collection_url, :collection_path,
        #               :new_resource_url, :new_resource_path,
        #               :edit_resource_url, :edit_resource_path,
        #               :parent_url, :parent_path,
        #               :smart_resource_url, :smart_collection_url
        # 
        # self.class_attribute :resource_class, :instance_writer => false unless self.respond_to? :resource_class
        # self.class_attribute :parents_symbols,  :resources_configuration, :instance_writer => false
        # 
        # protected :resource_class, :parents_symbols, :resources_configuration,
        #   :resource_class?, :parents_symbols?, :resources_configuration?
      end
    end

    inherit_resources(self)
  
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
      content_tag :div, class: "form-actions" do
        concat link_to('Anuluj', controller, class: "btn")
        concat " "
        concat f.button(:submit, class: "btn-success")
      end
    end

    def table_standard_buttons_tag(element)
      content_tag :span, class: "pull-right" do
        concat link_to('Edytuj', send("edit_#{element.class.name.underscore}_path", element), class: "btn btn-small") if can? :update, element
        concat " "
        concat link_to('Usuń', element, method: :delete, data: { confirm: 'Czy jesteś pewien?' }, class: "btn btn-small btn-danger") if can? :destroy, element
      end
    end

    IGNORED_COLUMNS = %w(id created_at updated_at) 

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
