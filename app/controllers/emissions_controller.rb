class EmissionsController < ApplicationController
  helper_method :theme_title

  def index
    @p = ThemePresenter::EmissionsPresenter.new
    render
  end

  def choropleth_data
    respond_to do |format|
      format.json do
        totals = ::GeoJSON::CensusTract.
          with_emissions_totals_where_year_scenario(
            choropleth_params[:year], choropleth_params[:scenario_id],
            choropleth_query_where_clause
          )
        render json: totals
      end
    end
  end

  def theme_title
    'Greenhouse Gas Emissions'
  end

private

  def choropleth_query_where_clause
    clause = {}
    unless choropleth_params[:sector_ids].include? "0"
      clause[:sector_id] = choropleth_params[:sector_ids].reject(&:blank?).map(&:to_i)
    end
    unless choropleth_params[:fuel_type_ids].include? "0"
      clause[:fuel_type_id] = choropleth_params[:fuel_type_ids].reject(&:blank?).map(&:to_i)
    end
    clause
  end

  def choropleth_params
    c_params = params.require(:choropleth_params).permit(
                :year, :scenario_id,
                {sector_ids: [], fuel_type_ids: []}
              )
    c_params[:year] = c_params[:year].to_i
    c_params[:scenario_id] = c_params[:scenario_id].to_i
    return c_params
  end

end