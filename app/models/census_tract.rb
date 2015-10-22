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

private

  def self.t
    arel_table
  end

end