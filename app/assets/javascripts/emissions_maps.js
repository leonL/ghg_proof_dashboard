$(function() {
  var map = L.map('map').setView([43.706226, -79.343184], 11);

  L.tileLayer('https://api.mapbox.com/v4/mapbox.streets/{z}/{x}/{y}.png?access_token={accessToken}', {
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
      maxZoom: 18,
      accessToken: 'pk.eyJ1IjoibGUwbmwiLCJhIjoiY2lld3dqZXF3MDhmMXNrbWFvM3A0c3plNiJ9.Gx3v7hkmHzmq3HE6vuIS1w'
  }).addTo(map);

  function getColor(d) {
      return d > 1 ? '#800026' :
             d > 0.8  ? '#BD0026' :
             d > 0.6  ? '#E31A1C' :
             d > 0.4  ? '#FC4E2A' :
             d > 0.3   ? '#FD8D3C' :
             d > 0.2  ? '#FEB24C' :
             d > 0.1   ? '#FED976' :
                        '#FFEDA0';
  }

  function style(feature) {
      return {
          fillColor: getColor(feature.properties.total),
          weight: 2,
          opacity: 1,
          color: 'white',
          dashArray: '3',
          fillOpacity: 0.7
      };
  }

  function polygons(d) {
    geos = d.features;

    geoJSONFeature = geos[0];
    L.geoJson(geos, {style: style}).addTo(map);
  }

  $.ajax({
     type: "GET",
     contentType: "application/json; charset=utf-8",
     url: 'total',
     dataType: 'json',
     success: polygons,
     error: function (result) {
         error();
     }
  });
});