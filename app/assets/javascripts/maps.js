// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.

$(document).ready(function () {
    $('.form.map-search').submit(function () {
        var valuesToSubmit = $(this).serialize();
        $.ajax({
            type: "GET",
            url: "/homepage/web", //sumbits it to the given url of the form
            data: valuesToSubmit,
            dataType: "JSON" // you want a difference between normal and ajax-calls, and json is standard
        }).complete(function (json) {
            updateMap(json.responseText);
            updateList(json.responseText);
        });
        return false; // prevents normal behaviour
    });

});

var map;
var geocoder = null;

// Initialize map on page with map
function initMap() {
    $('.form.map-search').submit(); // Call updateMap - show all markers
}

// Extract code or code_alliance text from one entry
function extractCode(data) {
    var kod = "";
    if (data.code_alliance || data.code) {
        if (data.code) {
            kod = "(" + data.code + ")"
        } else {
            kod = "(" + data.code_alliance + ")"
        }
    }
    return kod;
}

// Extract 'from' as formated date
function extractFrom(data) {
    var from = "";
    if (data.from) {
        from = $.datepicker.formatDate("dd.mm.yy", new Date(data.from));
    }
    return from;
}

// Extract 'to' as formated date
function extractTo(data) {
    var to = "";
    if (data.to) {
        to = $.datepicker.formatDate("dd.mm.yy", new Date(data.to));
    }
    return to;
}

// create link to this camp
function createLink(data) {
    return "<a href='/events/" + data.id + "/show_public' class='ui button' target=\"_blank\">Detail</a>"
}

// Extract unified camp details
function getCampDetails(data) {
    var from = "", to = "", cancelled = "";
    if (data.from) {
        from = $.datepicker.formatDate("dd.mm.yy", new Date(data.from));
    }
    if (data.to) {
        to = $.datepicker.formatDate("dd.mm.yy", new Date(data.to));
    }
    if (data.is_cancelled) {
        cancelled = "Event je zrušený!<br>"
    }


    return "<h4>" + data.title + " " + extractCode(data) + "</h4>" +
        cancelled +
        "od " + from + " do " + to + "<br>" +
        data.country + "<br>" +
        createLink(data);
}

// Create marker on selected map, with selected title on selected GPS position
function createMarker(position, title) {
    return new google.maps.Marker({
        position: position,
        //map: map,
        title: title,
        icon: "http://" + window.location.host + "/assets/inex_place_small.svg"
    });
}

// Called on search update
function updateMap(data) {
    if (!geocoder) {
        geocoder = new google.maps.Geocoder();
    }

    var json_data = JSON.parse(data);
    var inex = {lat: 48.126133, lng: 17.094493};
    map = new google.maps.Map(document.getElementById('map'), {
        zoom: 4,
        center: inex,
        styles: [
            {
                "stylers": [
                    {
                        "visibility": "on"
                    },
                    {
                        "weight": 1.5
                    }
                ]
            },
            {
                "elementType": "geometry",
                "stylers": [
                    {
                        "color": "#f5f5f5"
                    }
                ]
            },
            {
                "elementType": "labels.icon",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#616161"
                    }
                ]
            },
            {
                "elementType": "labels.text.stroke",
                "stylers": [
                    {
                        "color": "#f5f5f5"
                    }
                ]
            },
            {
                "featureType": "administrative.country",
                "elementType": "geometry.stroke",
                "stylers": [
                    {
                        "color": "#000000"
                    },
                    {
                        "visibility": "on"
                    },
                    {
                        "weight": 2
                    }
                ]
            },
            {
                "featureType": "administrative.land_parcel",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#bdbdbd"
                    }
                ]
            },
            {
                "featureType": "administrative.neighborhood",
                "elementType": "geometry.stroke",
                "stylers": [
                    {
                        "visibility": "on"
                    }
                ]
            },
            {
                "featureType": "poi",
                "elementType": "geometry",
                "stylers": [
                    {
                        "color": "#eeeeee"
                    }
                ]
            },
            {
                "featureType": "poi",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#757575"
                    }
                ]
            },
            {
                "featureType": "poi.park",
                "elementType": "geometry",
                "stylers": [
                    {
                        "color": "#e5e5e5"
                    }
                ]
            },
            {
                "featureType": "poi.park",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#9e9e9e"
                    }
                ]
            },
            {
                "featureType": "road",
                "elementType": "geometry",
                "stylers": [
                    {
                        "color": "#ffffff"
                    }
                ]
            },
            {
                "featureType": "road.arterial",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#757575"
                    }
                ]
            },
            {
                "featureType": "road.highway",
                "elementType": "geometry",
                "stylers": [
                    {
                        "color": "#dadada"
                    }
                ]
            },
            {
                "featureType": "road.highway",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#616161"
                    }
                ]
            },
            {
                "featureType": "road.local",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#9e9e9e"
                    }
                ]
            },
            {
                "featureType": "transit.line",
                "elementType": "geometry",
                "stylers": [
                    {
                        "color": "#e5e5e5"
                    }
                ]
            },
            {
                "featureType": "transit.station",
                "elementType": "geometry",
                "stylers": [
                    {
                        "color": "#eeeeee"
                    }
                ]
            },
            {
                "featureType": "water",
                "elementType": "geometry",
                "stylers": [
                    {
                        "color": "#c9c9c9"
                    }
                ]
            },
            {
                "featureType": "water",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#9e9e9e"
                    }
                ]
            }
        ]
    });
    var markers = [];

    $.each(json_data, function (key, data) {
        var latLng;
        var marker;
        if (data.gps_latitude && data.gps_longitude) {
            latLng = new google.maps.LatLng(data.gps_latitude, data.gps_longitude);
            marker = createMarker(latLng, data.title);
            bindInfoWindow(marker, getCampDetails(data));
            markers.push(marker);
        } else {
            //if (geocoder) {
            //    geocoder.geocode({'address': data.address + data.city + data.country}, function (results, status) {
            //        if (status == 'OK') {
            //            marker = createMarker(results[0].geometry.location, data.title);
            //            bindInfoWindow(marker, getCampDetails(data));
            //            markers.push(marker);
            //        }
            //    });
            //}
        }
    });

    var markerCluster = new MarkerClusterer(map, markers,
        {imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'});
}

// Binding for InfoWindow to show marker's window
function bindInfoWindow(marker, strDescription) {
    var infowindow = new google.maps.InfoWindow({
        content: strDescription
    });
    marker.addListener('click', function () {
        infowindow.open(map, marker);
    });
}


// Update search list
function updateList(data) {
    var json_data = JSON.parse(data);
    var tableContent = "";
    $.each(json_data, function (key, data) {
        tableContent += "<tr>"
        tableContent += "<td>" + data.title + "</td>";
        tableContent += "<td>" + extractCode(data) + "</td>";
        tableContent += "<td>" + data.country + "</td>";
        tableContent += "<td>" + extractFrom(data) + "</td>";
        tableContent += "<td>" + extractTo(data) + "</td>";
        tableContent += "<td>" + createLink(data) + "</td>";
        tableContent += "</tr>"
    });
    if (tableContent != "") {
        document.getElementById('map-search-table').innerHTML =
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
            '</tbody>'
        '</table>'
    } else {
        document.getElementById('map-search-table').innerHTML = "Podľa zadaných " +
            "parametrov nebol nájdený žiaden event. Skús svoje vyhľadávanie upraviť.";
    }
    document.getElementById('map-search-count').innerHTML = json_data.length;
}