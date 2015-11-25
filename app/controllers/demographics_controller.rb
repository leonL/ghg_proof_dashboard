class DemographicsController < ApplicationController

  def index
    @totals_by_age_group_chart = PlotlyChart.named('population_by_age_group').first
    render
  end

  def theme_title
    'Demographics'
  end

end