class GhgEmission < ActiveRecord::Base

  belongs_to :sector
  belongs_to :scenario

  def self.yearly_emissions_grouped_by(*factors)
    factor_cols = factors.map{|col_name| t["#{col_name}_id"]}
    factor_cols.unshift t[:year]

    query = t.project(factor_cols, t[:total_emissions].sum.as('total')).
      group(factor_cols).
      order(factor_cols)

    records = find_by_sql(query)

    preloader.preload(records, factors)
    records
  end

  def self.total_emissions_by_zone_for_year_for_scenario_query(year, scenario_id)
    t.project(t[:zone_id], t[:total_emissions].sum.as('total')).
      where(t[:year].eq(year)).
      where(t[:scenario_id].eq(scenario_id)).
      group(t[:zone_id]).
      as('ghg_totals')
  end

private

  def self.t
    arel_table
  end

  def self.preloader
    ActiveRecord::Associations::Preloader.new
  end
end