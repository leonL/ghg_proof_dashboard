class Emissions::ChartsController < ApplicationController

  def total # params: scenario_ids
    respond_to do |format|
      format.json do
      end

      format.html do
        @plotly_chart = PlotlyChart.named('emissions_total').first
        render
      end
    end
  end

  def by_sector
    @plotly_charts = PlotlyChart.named('emissions_by_sector')
  end

  def by_fuel
    @plotly_charts = PlotlyChart.named('emissions_by_fuel_type')
  end

end