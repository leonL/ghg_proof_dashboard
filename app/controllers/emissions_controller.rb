class EmissionsController < ApplicationController

  def index # params: scenario_ids
    respond_to do |format|

      format.html do
        @total_chart = PlotlyChart.named('emissions_total').first
        @by_sector_charts = PlotlyChart.named('emissions_by_sector')
        @by_fuel_type_charts = PlotlyChart.named('emissions_by_fuel_type')
        render
      end
    end
  end
end