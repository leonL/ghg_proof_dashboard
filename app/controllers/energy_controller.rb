class EnergyController < ApplicationController

  def index
    @total_chart = PlotlyChart.named('energy_totals').first
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