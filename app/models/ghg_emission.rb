class GhgEmission < ActiveRecord::Base

  def self.grouped_totals(*factors)
    totals = group(factors).sum(:total_emissions)
    formatted_totals = totals.map do |t|
      h = {ghg_emissions: t.last}
      groups = Array(t.first)
      groups.each_with_index do |g, i|
        h[factors[i]] = g
      end
      h
    end
    formatted_totals.sort_by{ |hsh| hsh[factors.first]}
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
end