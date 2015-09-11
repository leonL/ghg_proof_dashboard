class GhgEmission < ActiveRecord::Base

  def self.totals_by_scenario_year_(factor=nil)
    grouping_cols = [:scenario_id, :year]
    grouping_cols << factor if factor
    group(grouping_cols).sum(:total_emissions)
  end

  def self.for_json_totals_by_scenario_year_(factor=nil)
    totals = totals_by_scenario_year_(factor)
    scenarios = []
    totals.each do |t|
      scenarios[t.first.first] = {} if scenarios[t.first.first].nil?
      scenarios[t.first.first][t.first.last] = t.last
    end
    scenarios
  end
end