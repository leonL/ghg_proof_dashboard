class ThemePresenter

  def all_scenarios
    @scenarios ||= Scenario.includes(:colour)
  end

  def bau_scenario
    @bau_scenario ||= scenarios.find &:bau
  end

  def plotly_charts
    nil
  end

  @total_chart = PlotlyChart.named('energy_totals').first
  @energy_summaries = EnergySummary.includes(:scenario)

end