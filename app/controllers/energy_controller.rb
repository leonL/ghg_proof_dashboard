class EnergyController < ApplicationController

  def index
    @total_chart = PlotlyChart.named('energy_totals').first
    @by_sector_charts = PlotlyChart.named('energy_by_sector')
    @by_fuel_type_charts = PlotlyChart.named('energy_by_fuel_type')
    @energy_summaries = EnergySummary.includes(:scenario)
    render
  end

  def choropleth_data
    respond_to do |format|
      format.json do
        # totals = ::GeoJSON::CensusTract.
        #   with_emissions_totals_where_year_scenario(
        #     choropleth_params[:year], choropleth_params[:scenario_id],
        #     choropleth_query_where_clause
        #   )
        # render json: totals
      end
    end
  end

private

end