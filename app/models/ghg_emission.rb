class GhgEmission < ActiveRecord::Base

  belongs_to :scenario
  belongs_to :fuel_type
  belongs_to :sector
  belongs_to :zone, class_name: 'CensusTract', foreign_key: :zone_id, inverse_of: :ghg_emissions

  def self.yearly_totals_by_factors(factors, where_vals)
    factor_cols = factors.map{|col_name| t["#{col_name}_id"]}
    factor_cols.unshift t[:year]

    query = t.project(factor_cols, t[:total_emissions].sum.as('total')).
      group(factor_cols).
      order(factor_cols)

    where_vals.each do |col_name, val|
      query = query.where(t[col_name].eq(val))
    end

    records = find_by_sql(query)

    preloader.preload(records, factors)
    records
  end

  def self.totals_by_factors_for_year_scenario(year, scenario_id, factors = [:scenario])
    records = yearly_totals_by_factors(all_factors, {year: year, scenario_id: scenario_id})
    geo_features = records.map do |record|
      properties = factors.inject({}) do |hash, factor|
        hash["#{factor}_id".to_sym] = record.read_attribute("#{factor}_id")
        hash
      end
      properties[:total] = record.total
      geo_factory.feature(record.zone.geom, record.zone.id, properties)
    end
    geo_factory.feature_collection geo_features
  end

private

  def self.t
    arel_table
  end

  def self.preloader
    ActiveRecord::Associations::Preloader.new
  end

  def self.geo_factory
    RGeo::GeoJSON::EntityFactory.instance
  end
end