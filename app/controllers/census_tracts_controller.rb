class CensusTractsController < ApplicationController

  def index
    @tracts = CensusTract.with_total_emissions_for_year_for_scenario(2015, 0)

    respond_to do |format|
      format.json do
        feature_collection = CensusTract.to_feature_collection @tracts
        render json: RGeo::GeoJSON.encode(feature_collection)
      end

      format.html do
        feature_collection = CensusTract.to_feature_collection @tracts
        @json = RGeo::GeoJSON.encode(feature_collection).to_json
        render
      end
    end
  end
end