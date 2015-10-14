class Emissions::MapsController < ApplicationController

  def total

    respond_to do |format|
      format.json do
        @totals = GhgEmission.yearly_emissions_by_factors_as_geo_features(2030, 1)
        render json: RGeo::GeoJSON.encode(@totals)
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