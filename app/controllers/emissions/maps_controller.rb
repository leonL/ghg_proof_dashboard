class Emissions::MapsController < ApplicationController

  def total

    @tracts = CensusTract.with_total_emissions_for_year_for_scenario(2015, 0)

    respond_to do |format|
      format.json do
        feature_collection = CensusTract.to_feature_collection @tracts
        render json: RGeo::GeoJSON.encode(feature_collection)
      end

      format.html do
      end
    end
  end

  def by_sector

  end

  def by_fuel

  end

end