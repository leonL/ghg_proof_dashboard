class GeoJSON::CensusTract < GeoJSON::Base

  def self.with_emissions_totals_where_year_scenario_geo_json(year, scenario_id, other={})
    records = model.with_emissions_totals_where_year_scenario(year, scenario_id, other)

    geo_features = records.map do |record|
      properties = {
        total: record.total,
        year: year,
        scenario_id: scenario_id
      }
      properties.merge other
      factory.feature(record.geom, record.id, properties)
    end

    features = factory.feature_collection geo_features
    rgeo.encode(features)
  end

  def self.model
    ::CensusTract
  end

end