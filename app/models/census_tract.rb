class CensusTract < ActiveRecord::Base

  has_many :ghg_emissions, primary_key: :zone_id, foreign_key: :zone_id, inverse_of: :census_tract

  def self.with_emissions_totals_where_year_scenario(year, scenario_id, other={})
    where = other.merge({year: year, scenario_id: scenario_id})
    subquery = GhgEmission.yearly_totals_by_factors_query([:zone], where).as('ghg_totals')

    query = t.project(Arel.star).
              join(subquery).
              on(t[:zone_id].eq(subquery[:zone_id]))

    find_by_sql(query)
  end

  def self.with_emissions_totals_where_year_scenario_geo_json(year, scenario_id, other={})
    records = with_emissions_totals_where_year_scenario(year, scenario_id, other)

    geo_features = records.map do |record|
      properties = {
        total: record.total,
        year: year,
        scenario_id: scenario_id
      }
      properties.merge other
      geo_json_factory.feature(record.geom, record.id, properties)
    end

    features = geo_json_factory.feature_collection geo_features
    RGeo::GeoJSON.encode(features)
  end


private

  def self.t
    arel_table
  end

  def self.geo_json_factory
    RGeo::GeoJSON::EntityFactory.instance
  end

end