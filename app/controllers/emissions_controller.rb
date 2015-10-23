class EmissionsController < ApplicationController

  def index
    @total_chart = PlotlyChart.named('emissions_total').first
    @by_sector_charts = PlotlyChart.named('emissions_by_sector')
    @by_fuel_type_charts = PlotlyChart.named('emissions_by_fuel_type')
    render
  end

  def choropleth_data
    respond_to do |format|
      format.json do
        totals = ::GeoJSON::CensusTract.
          with_emissions_totals_where_year_scenario(
            year_param, 2, {sector_id: 2, fuel_type_id: 1}
          )
        render json: totals
      end
    end
  end

  def year_param
    params[:year].to_i
  end

end