class PlotlyChartBuilder::EmissionsBySector < PlotlyChartBuilder

  def chart_type
    :area
  end

  def args
    sectors = []
    totals = GhgEmission.total_emissions_grouped_by_where(:sector_id, :year, scenario_id)

    totals.in_groups(4) do |group|
      sectors << group
    end

    data = []
    sectors.each_with_index do |sector, i|
      line = {x: [], y: [], fill: 'tonexty'}
      sector.each_with_index do |totals, y|
        line[:x] << totals.year
        total = 0
        0.upto(i) do |sctr|
          total += sectors[sctr][y].total
        end
        line[:y] << total
      end
      data << line
    end
    data
  end

  def kwargs
    super.merge(
      {
        fileopt: 'overwrite',
        style: { type: 'scatter' },
        layout: {
          title: 'Emissions By Sector'
        }
      }
    )
  end

# Utility

  def scenario_id
    owner.scenario_id
  end

end