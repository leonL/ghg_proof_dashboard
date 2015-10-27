function togglePanes($context) {
  var $paneSelector = $context.find('select.panes'),
      $allPanes = $context.find('.pane');

  $paneSelector.on('change', function() {
    var selectedPaneId = $(this).val();
    $allPanes.removeClass('active');
    $allPanes.filter("#" + selectedPaneId).addClass('active');
  });
}

function choropleth($context, totals_range) {

  var
  $map = $context.find('.choropleth-map'),
  $form = $context.find('form#choropleth-controls'),
  map = L.map($map.get(0)).setView([43.706226, -79.343184], 10),
  colorScale = d3.scale.quantize().domain(totals_range).range(colorbrewer.Reds[9]),
  visibleLayer = null;

  L.tileLayer('https://api.mapbox.com/v4/mapbox.streets/{z}/{x}/{y}.png?access_token={accessToken}', {
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
      maxZoom: 18,
      accessToken: 'pk.eyJ1IjoibGUwbmwiLCJhIjoiY2lld3dqZXF3MDhmMXNrbWFvM3A0c3plNiJ9.Gx3v7hkmHzmq3HE6vuIS1w'
  }).addTo(map);

  function initControls(yearExtent) {
    var
    $yearSlider = $form.find(".year-slider"),
    $yearInput = $("input#choropleth_params_year"),
    $getDataButton = $form.find('button.submit'),
    yearRange = yearInputRange(yearExtent);

    $yearInput.val(yearRange[0]);

    $yearSlider.slider({
      value: 0,
      min: 0,
      max: yearRange.length - 1,
      step: 1,
      slide: function(event, ui) {
        $yearInput.val(yearRange[ui.value]);
      }
    });

    $form.on('ajax:success', function(e, data, status, xhr) {
      var geoJSONLayer = L.geoJson(data.features, {style: style});
      if (visibleLayer) {
        map.removeLayer(visibleLayer);
      }
      map.addLayer(geoJSONLayer);
      visibleLayer = geoJSONLayer;
    });

    // $getDataButton.click();
  }

  function yearInputRange(yearExtent) {
    var
    inclusionThreshold = 3,
    minYear = yearExtent[0],
    firstDecade = Util.nextTens(minYear),
    maxYear = yearExtent[1],
    lastDecade = Util.previousTens(maxYear),
    decadeStep = 10;

    if (firstDecade - minYear <= inclusionThreshold) {
      firstDecade += 10;
    }

    if (maxYear - lastDecade <= inclusionThreshold) {
      lastDecade -= 10;
    }

    var inputRange = _.range(firstDecade, lastDecade + 10, 10);

    inputRange.unshift(minYear);
    inputRange.push(maxYear);
    return(inputRange);
  }

  function style(feature) {
      return {
          fillColor: colorScale(feature.properties.total),
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