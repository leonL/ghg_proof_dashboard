module EmissionsHelper

  def all_zone_totals_90_percentile_bounds
    records = GhgEmission.descending_yearly_totals_by_zone_scenario_year
    decile_n = records.count / 10
    bounds = [records[decile_n], records[-decile_n]]
    bounds.map!{|record| record.total.to_f}
  end

  def select_options_for_factor(factor, all_option=true)
    scenario_names_and_ids = factor.map do |scenario|
      [scenario.name, scenario.id]
    end
    scenario_names_and_ids.unshift ['All', 0] if all_option
    options_for_select(scenario_names_and_ids)
  end

end