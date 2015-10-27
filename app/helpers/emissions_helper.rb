module EmissionsHelper

  def all_zone_totals_90_percentile_bounds
    records = GhgEmission.descending_yearly_totals_by_zone_scenario_year
    decile_n = records.count / 10
    bounds = [records[decile_n], records[-decile_n]]
    bounds.map!{|record| record.total.to_f}
  end

  def scenario_select_options
    scenario_names_and_ids = @scenarios.map do |scenario|
      [scenario.name, scenario.id]
    end
    options_for_select(scenario_names_and_ids)
  end

end