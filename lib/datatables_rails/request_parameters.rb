class RequestParameters
  attr_accessor :params

  def initialize(params)
    @params = params
  end

  def echo_number
    params[:sEcho].to_i
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column_index
    params[:iSortCol_0].to_i
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def search_text
    params[:sSearch]
  end
end