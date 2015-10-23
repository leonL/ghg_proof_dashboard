function togglePanes($context) {
  var $paneSelector = $context.find('select.panes'),
      $allPanes = $context.find('.pane');

  $paneSelector.on('change', function() {
    var selectedPaneId = $(this).val();
    $allPanes.removeClass('active');
    $allPanes.filter("#" + selectedPaneId).addClass('active');
  });
}

function choropleth($context) {

  var
  $map = $context.find('.choropleth-map'),
  $form =$context.find('form#choropleth-controls'),
  map = L.map($map.get(0)).setView([43.706226, -79.343184], 10);

  L.tileLayer('https://api.mapbox.com/v4/mapbox.streets/{z}/{x}/{y}.png?access_token={accessToken}', {
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
      maxZoom: 18,
      accessToken: 'pk.eyJ1IjoibGUwbmwiLCJhIjoiY2lld3dqZXF3MDhmMXNrbWFvM3A0c3plNiJ9.Gx3v7hkmHzmq3HE6vuIS1w'
  }).addTo(map);

  function initControls(yearRange) {
    var
    $yearSlider = $form.find(".year-slider"),
    $yearInput = $("input#year"),
    $getDataButton = $form.find('button.submit')
    minYear = yearRange[0],
    maxYear = yearRange[1],
    initialYear = minYear + Math.round((maxYear - minYear) / 2);

    $yearInput.val(initialYear);

    $yearSlider.slider({
      value: initialYear,
      min: minYear,
      max: maxYear,
      step: 1,
      slide: function(event, ui) {
        $yearInput.val(ui.value);
      }
    });

    $form.on('ajax:success', function(e, data, status, xhr) {
      L.geoJson(data.features, {style: style}).addTo(map);
    });

    // $getDataButton.click();
  }

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

  return {
    initControls: initControls
  };
}