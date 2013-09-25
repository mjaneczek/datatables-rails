$ ->
  sorting_column = $('#datatables_rails').data('sorting_column')
  sorting_type = $('#datatables_rails').data('sorting_type')
  disable_edit_delete = $('#datatables_rails').data('disable_edit_delete')

  $.extend $.fn.dataTableExt.oStdClasses,
    sWrapper: "dataTables_wrapper form-inline"

  o_table = $("#datatables_rails").dataTable(
    aaSorting: [[ sorting_column, sorting_type ]],
    bSortClasses: false
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#datatables_rails').data('source')
    aoColumnDefs: [
      bSortable: false
      aTargets: [$("#datatables_rails thead tr th").length - 1].concat($('#datatables_rails').data('column_without_sorting'))
    ] unless disable_edit_delete
    fnServerParams: (aoData) ->
        column_filter = $("#selected_column").val()
        aoData.push({name: "column_filter", value: column_filter})
    oLanguage:
      sLengthMenu: "_MENU_ wyników na stronie"
      sZeroRecords: "Nie znaleziono szukanego fragmentu"
      sInfo: "_START_ - _END_ z _TOTAL_ elementów"
      sInfoEmpty: ""
      sSearch: ""
      sProcessing: "Ładowanie..."
      sInfoFiltered: "(wyszukano z _MAX_ elementów)"
      oPaginate:
        sFirst: "Pierwsza"
        sPrevious: "Poprzednia"
        sNext: "Następna"
        sLast: "Ostatnia"
  )

  $("#selected_column").change ->
    o_table.fnDraw()
