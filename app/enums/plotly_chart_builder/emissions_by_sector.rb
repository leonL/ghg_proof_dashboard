class PlotlyChartBuilder::EmissionsBySector < PlotlyChartBuilder::EmissionsByFactor

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

end