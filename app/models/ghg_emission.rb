class GhgEmission < ActiveRecord::Base

  def self.total_emissions_grouped_by(*factors)
    factor_cols = factors.map{|col_name| cl(col_name)}
    q = t.project(factor_cols, t[:total_emissions].sum.as('total')).
      group(factor_cols).
      order(factor_cols)
    find_by_sql(q)
  end

  def self.total_emissions_grouped_by_where(*factors, s_id)
    factor_cols = factors.map{|col_name| cl(col_name)}
    q = t.project(factor_cols, t[:total_emissions].sum.as('total')).
      where(cl(:scenario_id).eq(s_id)).
      group(factor_cols).
      order(factor_cols)
    find_by_sql(q)
  end

  def self.total_emissions_by_zone_for_year_for_scenario_query(year, scenario_id)
    t.project(t[:zone_id], t[:total_emissions].sum.as('total')).
      where(t[:year].eq(year)).
      where(t[:scenario_id].eq(scenario_id)).
      group(t[:zone_id]).
      as('ghg_totals')
  end

  def self.for_year(year)
    where(year: year)
  end

  def self.for_scenario(id)
    where(scenario_id: id)
  end

private

  def self.t
    arel_table
  end

  def self.cl(column_name)
    t[column_name]
  end
end