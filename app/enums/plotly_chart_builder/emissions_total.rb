class PlotlyChartBuilder::EmissionsTotal < PlotlyChartBuilder

# value querying logic

  def totals
    @totals ||= GhgEmission.yearly_emissions_by_factors([:scenario])
  end

# args hash and related logic

  def args
    plot_coordinates = []
    all_scenarios.each do |scenario|
      line = {
        x: all_years_sequenced,
        y: y_values_grouped_by_secnario_id_sequenced[scenario.id],
        name: scenario.name,
        hoverinfo: 'none'
      }
      plot_coordinates << line
    end
    plot_coordinates
  end

  def y_values_grouped_by_secnario_id_sequenced
    @y_vals ||= begin
      totals_array = totals.group_by(&:scenario_id).map do |s_id, totals|
        [s_id, totals.map(&:total)]
      end
      totals_array.to_h
    end
  end

  def max_y_value
    @max_y_value ||= begin
      scenario_maximums = []
      y_values_grouped_by_secnario_id_sequenced.each do |y_vals|
        scenario_maximums << y_vals.last.max
      end
      scenario_maximums.max
    end
  end

  def all_years_sequenced
    @years ||= totals.uniq(&:year).map(&:year)
  end

  def all_scenarios
    @scenario_ids = totals.uniq(&:scenario_id).map(&:scenario)
  end

# kwargs hash and related logic

  def kwargs
    super.merge(
      {
        style: { type: 'scatter' }
      }
    )
  end

  def layout
    super.merge(
      {
        margin: {t: 37, r: 20, l: 50, b: 52},
        title: 'Projected Yearly GHG Emissions',
        titlefont: {
          family: "Arial, sans-serif",
          size: 16,
          color: "black"
        },
        xaxis: {
          title: 'Year',
          titlefont: {
            family: "Arial, sans-serif",
            size: 12,
            color: "black"
          },
          range: [all_years_sequenced.first, all_years_sequenced.last],
          ticks: 'outside',
          tick0: 0,
          dtick: 10,
          showline: true,
          showgrid: true,
          zeroline: false
        },
        yaxis: {
          title: 'Mt',
          titlefont: {
            family: "Arial, sans-serif",
            size: 12,
            color: "black"
          },
          range: [0, max_y_value.to_i.round(-1)],
          ticks: '',
          dtick: 20,
          ticklen: 20,
          tickcolor: "rgb(255, 255, 255)",
          showline: true,
          showgrid: true,
          zeroline: false
        },
      }
    )
  end

end