this.DatatablesRails = class DatatablesRails
  constructor: (language_file) ->
    this.load_data_from_table()

    $("#datatables_rails").dataTable(
      sAjaxSource: @data_source,
      aaSorting: [[ @sorting_column, @sorting_type ]],
      bSortClasses: false
      bProcessing: true
      bServerSide: true
      aoColumnDefs: [
        bSortable: false
        aTargets: @columns_without_sorting
      ]
      oLanguage:
        (sUrl: language_file) if language_file
    )

  load_data_from_table: ->
    @sorting_column = $('#datatables_rails').data('sorting_column')
    @sorting_type = $('#datatables_rails').data('sorting_type')
    @columns_without_sorting = $('#datatables_rails').data('columns_without_sorting')
    @data_source = $('#datatables_rails').data('source')