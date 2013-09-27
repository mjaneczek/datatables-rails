#= require jquery
#= require datatables_rails.js.coffee

describe "DatatablesRails", ->
  table = null
  dataTableFunction = null

  beforeEach ->
    dataTableFunction = spy_datatable_function()
    spyOn($.fn, "data").andCallFake(fake_data)
    table = new DatatablesRails("path_to_file")

  spy_datatable_function = ->
    $.fn.dataTable = (params) ->
    spyOn($.fn, 'dataTable')

  fake_data = (name) ->
    "fake #{name}"

  parameters = {
      sAjaxSource: "fake source"
      aaSorting: [["fake sorting_column", "fake sorting_type"]]
      bSortClasses: false
      bProcessing: true
      bServerSide: true
      aoColumnDefs: [
        bSortable: false
        aTargets: "fake columns_without_sorting"
      ]
      oLanguage:
        sUrl: "path_to_file"
      }

  it "should pass arguments from table data to datatable function", ->
    table.init()
    expect(dataTableFunction).toHaveBeenCalledWith(parameters)

  it "should pass additional data from additional_params method", ->
    function_adding_params = (data) ->
      data.push({ name: "additional_param_name", value: "additional_param_value" })

    table.additional_params = function_adding_params
    table.init()
    
    parameters["fnServerParams"] = function_adding_params
    expect(dataTableFunction).toHaveBeenCalledWith(parameters)