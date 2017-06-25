# jQuery for Google maps API

jQuery ->
# Form submitter for maps search
  $('.form.map-search').on 'submit', ->
    valuesToSubmit = $(this).serialize()
    $.ajax "/homepage/map_search",
      type: 'GET'
      data: valuesToSubmit
      dataType: 'JSON'
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "Error getting results in map search."
      complete: (json, textStatus, jqXHR) ->
        updateMap(json.responseText);
        updateList(json.responseText);

  # Extract code or code_alliance
  extractCode = (data) ->
    code = ""
    if data.code
      code = "(" + data.code + ")"
    else if data.code_alliance
      code = "(" + data.code_alliance + ")"
    code

  extractFrom = (data) ->
    from = ""
    if data.from
      from = $.datepicker.formatDate("dd.mm.yy", new Date(data.from))
    from

  extractTo = (data) ->
    to = ""
    if data.to
      to = $.datepicker.formatDate("dd.mm.yy", new Date(data.to))
    to

  # Returns link to event
  linkToEvent = (data) ->
    "<a href='/events/" + data.id + "/show_public' class='ui button' target=\"_blank\">Detail</a>"

  getCampDetails = (data) ->
    cancelled = ""
    if data.is_cancelled
      cancelled = "Event je zrušený!<br>"
    "<h4>" + data.title + " " + extractCode(data) + "</h4>" +
      cancelled +
      "od " + extractFrom(data) + " do " + extractTo(data) + "<br>" +
      data.country + "<br>" +
      linkToEvent(data)

  createMarker = (position, title) ->
    new google.maps.Marker({
      position: position,
      title: title,
      icon: window.location.protocol + '//' + window.location.host + "/assets/inex_place_small.svg"
    })

  updateMap = (data) ->
    geocoder = new google.maps.Geocoder()
    json_data = JSON.parse(data)
    inex = {lat: 48.126133, lng: 17.094493}
    map = new google.maps.Map(document.getElementById('map'), {
      zoom: 4,
      center: inex,
      styles: [
        {"stylers": [{"visibility": "on"}, {"weight": 1.5}]},
        {"elementType": "geometry", "stylers": [{"color": "#f5f5f5"}]},
        {"elementType": "labels.icon", "stylers": [{"visibility": "off"}]},
        {"elementType": "labels.text.fill", "stylers": [{"color": "#616161"}]},
        {
          "elementType": "labels.text.stroke",
          "stylers": [{"color": "#f5f5f5"}]
        },
        {
          "featureType": "administrative.country",
          "elementType": "geometry.stroke",
          "stylers": [{"color": "#000000"}, {"visibility": "on"}, {"weight": 2}]
        },
        {
          "featureType": "administrative.land_parcel",
          "elementType": "labels.text.fill",
          "stylers": [{"color": "#bdbdbd"}]
        },
        {
          "featureType": "administrative.neighborhood",
          "elementType": "geometry.stroke",
          "stylers": [{"visibility": "on"}]
        },
        {
          "featureType": "poi",
          "elementType": "geometry",
          "stylers": [{"color": "#eeeeee"}]
        },
        {
          "featureType": "poi",
          "elementType": "labels.text.fill",
          "stylers": [{"color": "#757575"}]
        },
        {
          "featureType": "poi.park",
          "elementType": "geometry",
          "stylers": [{"color": "#e5e5e5"}]
        },
        {
          "featureType": "poi.park",
          "elementType": "labels.text.fill",
          "stylers": [{"color": "#9e9e9e"}]
        },
        {
          "featureType": "road",
          "elementType": "geometry",
          "stylers": [{"color": "#ffffff"}]
        },
        {
          "featureType": "road.arterial",
          "elementType": "labels.text.fill",
          "stylers": [{"color": "#757575"}]
        },
        {
          "featureType": "road.highway",
          "elementType": "geometry",
          "stylers": [{"color": "#dadada"}]
        },
        {
          "featureType": "road.highway",
          "elementType": "labels.text.fill",
          "stylers": [{"color": "#616161"}]
        },
        {
          "featureType": "road.local",
          "elementType": "labels.text.fill",
          "stylers": [{"color": "#9e9e9e"}]
        },
        {
          "featureType": "transit.line",
          "elementType": "geometry",
          "stylers": [{"color": "#e5e5e5"}]
        },
        {
          "featureType": "transit.station",
          "elementType": "geometry",
          "stylers": [{"color": "#eeeeee"}]
        },
        {
          "featureType": "water",
          "elementType": "geometry",
          "stylers": [{"color": "#c9c9c9"}]
        },
        {
          "featureType": "water",
          "elementType": "labels.text.fill",
          "stylers": [{"color": "#9e9e9e"}]
        }
      ]
    })

    markers = []
    for key, data of json_data
      if data.gps_latitude && data.gps_longitude
        latLng = new google.maps.LatLng(data.gps_latitude, data.gps_longitude)
        marker = createMarker(latLng, data.title)
        bindInfoWindow(marker, getCampDetails(data))
        markers.push(marker)

    markerCluster = new MarkerClusterer(map, markers,
      {imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'})

  # Global info window (show max one)
  infowindow = null
  bindInfoWindow = (marker, strDescription) ->
    marker.addListener('click', (() ->
      if infowindow
        infowindow.close()
      infowindow = new google.maps.InfoWindow({
        content: strDescription
      })
      infowindow.open(map, marker)
    ))

  updateList = (data) ->
    json_data = JSON.parse(data)
    tableContent = ""
    for key, data of json_data
      tableContent += "<tr>"
      tableContent += "<td>" + data.title + "</td>";
      tableContent += "<td>" + extractCode(data) + "</td>";
      tableContent += "<td>" + data.country + "</td>";
      tableContent += "<td>" + extractFrom(data) + "</td>";
      tableContent += "<td>" + extractTo(data) + "</td>";
      tableContent += "<td>" + linkToEvent(data) + "</td>";
      tableContent += "</tr>"
    if tableContent != ""
      $('#map-search-table').html(
        '<table class="ui compact celled green table" id="map-search-table">' +
          '<thead>' +
          '<tr>' +
          '<th>Názov</th>' +
          '<th>Kód</th>' +
          '<th>Krajina</th>' +
          '<th>Od</th>' +
          '<th>Do</th>' +
          '<th>Link</th>' +
          '</tr>' +
          '</thead>' +
          '<tbody>' +
          tableContent +
          '</tbody>' +
          '</table>'
      )
    else
      $('#map-search-table').html("Podľa zadaných " +
          "parametrov nebol nájdený žiaden event. Skús svoje vyhľadávanie upraviť.")
    $('#map-search-count').html(json_data.length)