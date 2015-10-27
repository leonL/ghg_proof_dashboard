class EmissionsController < ApplicationController

  def index
    @total_chart = PlotlyChart.named('emissions_total').first
    @by_sector_charts = PlotlyChart.named('emissions_by_sector')
    @by_fuel_type_charts = PlotlyChart.named('emissions_by_fuel_type')
    @scenarios = Scenario.all
    render
  end

  def choropleth_data
    respond_to do |format|
      format.json do
        totals = ::GeoJSON::CensusTract.
          with_emissions_totals_where_year_scenario(
            choropleth_params[:year], choropleth_params[:scenario_id]
          )
        render json: totals
      end
    end
  end

  def choropleth_params
    c_params = params.require(:choropleth_params).permit(:year, :scenario_id)
    c_params[:year] = c_params[:year].to_i
    c_params[:scenario_id] = c_params[:scenario_id].to_i
    return c_params
  end

end

# {sector_id: 2, fuel_type_id: 1}