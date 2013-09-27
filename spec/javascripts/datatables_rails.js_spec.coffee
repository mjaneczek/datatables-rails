#= require jquery
#= require datatables_rails.js.coffee

describe "DatatablesRails", ->
  table = null
  dataTableFunction = null

  beforeEach ->
    dataTableFunction = spy_datatable_function()
    spyOn($.fn, "data").andCallFake(fake_data)
    table = new DatatablesRails

  spy_datatable_function = ->
    $.fn.dataTable = (params) ->
    spyOn($.fn, 'dataTable')

  fake_data = (name) ->
    "fake #{name}"

  it "should pass arguments from table data to datatable function", ->
    expect(dataTableFunction).toHaveBeenCalledWith({
      sAjaxSource: "fake source"
      aaSorting: [["fake sorting_column", "fake sorting_type"]]
      bSortClasses: false
      bProcessing: true
      bServerSide: true
      aoColumnDefs: [
        bSortable: false
        aTargets: "fake columns_without_sorting"
      ]})