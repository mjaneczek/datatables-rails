<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  load_and_authorize_resource except: [:create]

  def index
    respond_with @<%= plural_table_name %>
  end

  def new
    respond_with @<%= singular_table_name %>
  end

  def edit
    respond_with @<%= singular_table_name %>
  end

  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>
    authorize! :create, @<%= singular_table_name %>
    @<%= orm_instance.save %>
    respond_with @<%= singular_table_name %>
  end

  def update
    @<%= orm_instance.update("#{singular_table_name}_params") %>
    respond_with @<%= singular_table_name %>
  end

  def destroy
    @<%= orm_instance.destroy %>
    respond_with @<%= singular_table_name %>
  end

  private
    def <%= "#{singular_table_name}_params" %>
      <%- if attributes_names.empty? -%>
      params[<%= ":#{singular_table_name}" %>]
      <%- else -%>
      params.require(<%= ":#{singular_table_name}" %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
      <%- end -%>
    end
end
<% end -%>