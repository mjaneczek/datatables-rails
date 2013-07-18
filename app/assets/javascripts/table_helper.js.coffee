$ ->
  sorting_column = $('#simple_table').data('sorting_column')
  sorting_type = $('#simple_table').data('sorting_type')
  disable_edit_delete = $('#simple_table').data('disable_edit_delete')

  $.extend $.fn.dataTableExt.oStdClasses,
    sWrapper: "dataTables_wrapper form-inline"

  o_table = $("#simple_table").dataTable(
    aaSorting: [[ sorting_column, sorting_type ]],
    bSortClasses: false
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#simple_table').data('source')
    aoColumnDefs: [
      bSortable: false
      aTargets: [$("#simple_table thead tr th").length - 1].concat($('#simple_table').data('column_without_sorting'))
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
      sInfoFiltered: "(wyszukano z _MAX_ elementów)"
      oPaginate:
        sFirst: "Pierwsza"
        sPrevious: "Poprzednia"
        sNext: "Następna"
        sLast: "Ostatnia"
  )

  $("#selected_column").change ->
    o_table.fnDraw()
