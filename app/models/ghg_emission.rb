class GhgEmission < ActiveRecord::Base

  def self.totals_by_scenario_year_(factor=nil)
    grouping_cols = [:scenario_id, :year]
    grouping_cols << factor if factor
    group(grouping_cols).sum(:total_emissions)
  end
end