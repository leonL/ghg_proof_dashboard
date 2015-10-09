class PlotlyChartBuilder::EmissionsTotal < PlotlyChartBuilder

# value querying logic

  def totals
    @totals ||= GhgEmission.yearly_emissions_grouped_by(:scenario)
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
        fileopt: 'overwrite',
        style: { type: 'scatter' },
        layout: {
          yaxis: {
            range: [0, 90]
          },
          title: 'Projected Total GHG Emissions'
        }
      }
    )
  end

end