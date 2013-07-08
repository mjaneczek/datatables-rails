sorting_column = "<%= options.try(:[], :sorting_column) || 0 %>";
sorting_type = "<%= options.try(:[], :sorting_type) || 'asc' %>";
disable_edit_delete = "<%= options.try(:[], :disable_edit_delete) || false %>";

o_table = null

$ ->
  return if o_table # Tymczasowe obejście - issue 5

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
      aTargets: [$("#simple_table thead tr th").length - 1]
    ] unless disable_edit_delete
    fnServerParams: (aoData) ->
        column_filter = $("#selected_column").val()
        aoData.push({name: "column_filter", value: column_filter});
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