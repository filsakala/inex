jQuery ->
  $.fn.dataTable.ext.classes.sPaging = 'dataTables_paginate ui pagination menu ';
  $('.datatable').DataTable();

  $('.datatable-server').DataTable({
    "processing": true,
    "serverSide": true,
    "ajax": "/#{$(".datatable-server").data('entity')}/search?eid=#{$(".datatable-server").data('eid')}",
  })
  $('.dataTables_length select').addClass('ui dropdown').dropdown()

  $('.datatable-server').on 'draw.dt', ->
    $('.dropdown').dropdown()

  $('.ui.homepage.search').search({
    apiSettings: {
      url: '/homepage/search_page?q={query}'
    }
  })

  $('.ui.bags.search').search({
    apiSettings: {
      url: "/event_types/{id}/bags_search?q={query}&page={page}&per_page={per_page}"
    }
  })

  $('.ui.participation_fees.search').search({
    apiSettings: {
      url: "/participation_fees/search?q={query}&page={page}&per_page={per_page}"
    }
  })

  $('.ui.eventTypeIndex.search').search({
    apiSettings: {
      url: "/events/search_events?q={query}"
    }
  })