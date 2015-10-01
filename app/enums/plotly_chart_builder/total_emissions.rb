class PlotlyChartBuilder::TotalEmissions < PlotlyChartBuilder

  def args
    scenarios = []
    GhgEmission.total_emissions_grouped_by_scenario_for_year.in_groups(3) do |group|
      scenarios << group
    end

    data = []
    scenarios.each do |scenario|
      line = {x: [], y: []}
      scenario.map do |totals|
        line[:x] << totals.year
        line[:y] << totals.total
      end
      data << line
    end
    data
  end

  def kwargs
    {
      filename: 'ghgproof_dashboard_line_chart',
      fileopt: 'overwrite',
      style: { type: 'scatter' },
      layout: {
        yaxis: {
          range: [0, 90]
        },
        title: 'Line Chart'
      }
    }
  end

  # def self.build(show_scenarios = [])
  #   d = data
  #   d.each_with_index do |datum, i|
  #     d[i] = d[i].merge({visible: 'legendonly'}) unless show_scenarios.include? i
  #   end
  #   puts d
  #   Plotly::ChartCreator.create(d, args)
  # end

end