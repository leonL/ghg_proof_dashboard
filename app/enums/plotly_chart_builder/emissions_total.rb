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
        name: scenario.name
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
        margin: {t: 10, r: 0, l: 35, b: 20},
        legend: {x: 1.02, y: 0.81},
        xaxis: {
          range: [2011, 2050],
          tick0: 10,
          dtick: 10,
          showline: false,
          showgrid: true,
          zeroline: false
        },
        yaxis: {
          range: [0, 90],
          tick0: 0,
          dtick: 20,
          ticks: 'outside',
          ticklen: 20,
          tickcolor: "rgb(255, 255, 255)",
          showline: false,
          showgrid: true,
          zeroline: false
        },
      }
    )
  end

end