class ThemePresenter::DemographicsPresenter < ThemePresenter
  attr_accessor :plotly_chart_names

  def initialize
    self.plotly_chart_names = ['population_by_age_group', 'household_totals']
    load_plotly_charts *plotly_chart_names
  end
end
