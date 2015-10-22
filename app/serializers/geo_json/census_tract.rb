class GeoJSON::CensusTract < GeoJSON::Base

  def self.with_emissions_totals_where_year_scenario(year, scenario_id, other={})
    records = model.with_emissions_totals_where_year_scenario(year, scenario_id, other)

    geo_features = records.map do |record|
      properties = {total: record.total}
      factory.feature(record.geom, record.id, properties)
    end
    features = factory.feature_collection geo_features

    vars = {
      year: year,
      year_range: year_range,
      scenario_id: scenario_id
    }

    rgeo.encode(features).merge({vars: vars})
  end

  def self.model
    ::CensusTract
  end

end