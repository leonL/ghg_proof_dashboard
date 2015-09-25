class CensusTract < ActiveRecord::Base
  include Featurable
  featurable :geom, [:zone_id, :total]

  def self.with_total_emissions_for_year_for_scenario(year, scenario_id)
    sq = total_emissions_subquery(year, scenario_id)
    q = arel_table.project(Arel.star).
          join(sq).
          on(t[:zone_id].eq(sq[:zone_id]))
    find_by_sql(q)
  end

  def self.total_emissions_subquery(year, scenario_id)
    GhgEmission.total_emissions_by_zone_for_year_for_scenario_query(year, scenario_id)
  end

private

  def self.t
    arel_table
  end

end