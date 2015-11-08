function togglePanes($context) {
  var $paneSelectorRadios = $context.find('.toggle input'),
      $allPanes = $context.find('.pane');

  $paneSelectorRadios.on('change', function() {
    var selectedPaneId = $(this).attr('id');
    $allPanes.removeClass('active');
    $allPanes.filter("#" + selectedPaneId).addClass('active');
  });
}

function toggleMapForms($context) {
  var
  $currentSettings = $context.find('.form-toggle'),
  $cancelButtons = $context.find('button.cancel');

  $currentSettings.on('click', function() {
    var $form = $(this).siblings('form');
    $form.slideToggle('slow');
  });

  $cancelButtons.on('click', function() {
    var $form = $(this).parents('form');
    $form.slideToggle('fast');
  });

  $('[data-toggle="tooltip"]').tooltip();
}

function toggleReductionsTables($context) {
  var
  $toggle = $context.find('.reductions-benchmarks'),
  $tables = $context.find('.table-wrapper'),
  $checkedRadio = $toggle.find(':checked');

  $tables.filter('.' + $checkedRadio.val()).show();

  $toggle.on('change', function(e) {
    $tables.hide();
    $tables.filter('.' + e.target.value).show();
  });
}

function twinChoropleths($context, totalAt90thPercentile, scenarios) {
  var
  $map1 = $context.find('.choropleth-map#cm1'),
  $map2 = $context.find('.choropleth-map#cm2'),
  $forms = $context.find('form'),
  $legendWrapper = $context.find('.col-xs-2'),
  maps = [initiateMap($map1), initiateMap($map2)],
  colourRamp = colorbrewer.Reds[9],
  allScenarios = scenarios;

  var
  emissionTotalUpperBound = function() {
    var
    upperBound = Math.round(totalAt90thPercentile * 1000); // megatonnes to kilotonnes
    return(upperBound - (upperBound % colourRamp.length)); // make totals evenly divisible by # of colour ramp steps
  }(),
  colorScale = d3.scale.quantize().domain([0, emissionTotalUpperBound]).range(colourRamp);

  legend = function(map) {
    var
    div = L.DomUtil.create('div', 'gradient legend'),
    stepSize = emissionTotalUpperBound / colourRamp.length,
    grades = _.range(0 , emissionTotalUpperBound, stepSize),
    labels = [];

    // loop through our density intervals and generate a label with a colored square for each interval
    for (var i = 0; i < grades.length; i++) {
        div.innerHTML +=
            '<i style="background:' + colorScale(grades[i] + 1) + '"></i> ' +
            grades[i] + (grades[i + 1] ? '&ndash;' + grades[i + 1] + '<br>' : '+');
    }

    return div;
  };

  var $legend = $(legend());
  $legend.appendTo($legendWrapper);
  $('<div class="units"><label>kilotonnes</label></div>').appendTo($legend);

  function initForms() {

    $forms.each(function(i) {
      var
      map = maps[i],
      $form = $(this),
      visibleLayer = null;

      $form.on('ajax:success', function(e, data, status, xhr) {
        var geoJSONLayer = L.geoJson(data.features, {style: style});

        if (visibleLayer) {
          map.removeLayer(visibleLayer);
        }
        map.addLayer(geoJSONLayer);

        updateCurrentSettingsEl($(this));
        $(this).hide();
        visibleLayer = geoJSONLayer;
      });
    });

    return $forms;
  }

  function updateCurrentSettingsEl($form) {
    function setLabelText($el, text) {
      $el.contents().last()[0].textContent = (' ' + text);
    }

    function optionsTextToCommaString($opts) {
      var text = _.map($opts, function(el) { return el.textContent; });
      return text.join(', ');
    }

    var
    $currentSettings = $form.siblings('.current-settings'),
    $currentScenario = $currentSettings.find('li#scenario'),
    $currentYear = $currentSettings.find('li#year'),
    $currentSectors = $currentSettings.find('li#sectors'),
    $currentFuelTypes = $currentSettings.find('li#fuel-types'),

    selectedScenarioId = $form.find('select#choropleth_params_scenario_id option:selected').val(),
    selectedScenario = _.find(allScenarios, function(s) { return s.id == selectedScenarioId; }),
    selectedYear = $form.find('#choropleth_params_year option:selected').val(),
    selectedSectors = optionsTextToCommaString($form.find('#choropleth_params_sector_ids option:selected')),
    selectedFuelTypes = optionsTextToCommaString($form.find('#choropleth_params_fuel_type_ids option:selected'));

    $currentSettings.show();

    setLabelText($currentScenario, selectedScenario.name);
    $currentScenario.find('i').css('background-color', selectedScenario.colour.hex);
    setLabelText($currentYear, selectedYear);
    setLabelText($currentSectors, selectedSectors);
    setLabelText($currentFuelTypes, selectedFuelTypes);

    return null;
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

  function initiateMap($el) {
    var map = L.map($el.get(0)).setView([43.706226, -79.343184], 10);
    L.tileLayer('https://api.mapbox.com/v4/mapbox.streets/{z}/{x}/{y}.png?access_token={accessToken}', {
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
      maxZoom: 18,
      accessToken: 'pk.eyJ1IjoibGUwbmwiLCJhIjoiY2lld3dqZXF3MDhmMXNrbWFvM3A0c3plNiJ9.Gx3v7hkmHzmq3HE6vuIS1w'
    }).addTo(map);
    return(map);
  }

  return {
    initForms: initForms
  };
}