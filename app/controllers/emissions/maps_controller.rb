class Emissions::MapsController < ApplicationController

  def total

    respond_to do |format|
      format.json do
        @totals = ::GeoJSON::CensusTract.with_emissions_totals_where_year_scenario_geo_json(
                                  2030, 2, {sector_id: 2, fuel_type_id: 1})
        render json: @totals
      end

      format.html do
      end
    end
  end
end