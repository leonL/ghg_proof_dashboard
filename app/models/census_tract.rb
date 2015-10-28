class CensusTract < ActiveRecord::Base

  has_many :ghg_emissions, primary_key: :zone_id, foreign_key: :zone_id, inverse_of: :census_tract

  def self.with_emissions_totals_where_year_scenario(year, scenario_id, other_where_eq_in={})
    # build GhgEmission subquery that will be joined
    where = other_where_eq_in.merge({year: year, scenario_id: scenario_id})
    subquery = yearly_emissions_totals_by_zones_query(where)

    # transportation sector totals do not map meaninfgully and should be removed
    subquery = subquery.where(
                  emission_t[:sector_id].
                  not_eq(sector_id_for('Transportation'))
                ).as('ghg_totals')

    query = t.project(Arel.star).
              join(subquery).
              on(t[:zone_id].eq(subquery[:zone_id]))

    find_by_sql(query)
  end

private

  def self.sector_id_for(name)
    Sector.find_by_name(name).id
  end

  def self.yearly_emissions_totals_by_zones_query(where_clause)
    emission_model.yearly_totals_by_factors_query([:zone], where_clause)
  end

  def self.emission_model
    GhgEmission
  end

  def self.t
    arel_table
  end

  def self.emission_t
    emission_model.arel_table
  end

end