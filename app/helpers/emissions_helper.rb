module EmissionsHelper

  def reductions_grouped_by_benchmark_type
    @reductions_grouped ||= @reduction_summaries.group_by(&:benchmark_type)
  end

  def all_zone_totals_90th_percentile
    records = GhgEmission.descending_yearly_totals_by_zone_scenario_year
    decile_n = records.count / 10
    records[-decile_n].total.to_f
  end

  def select_options_for_factor(factor, all_option=true)
    scenario_names_and_ids = factor.map do |scenario|
      [scenario.name, scenario.id]
    end
    scenario_names_and_ids.unshift ['All', 0] if all_option
    options_for_select(scenario_names_and_ids, scenario_names_and_ids.first.last)
  end

  def select_options_for_year
    [[2011, 2011], [2020, 2020], [2030, 2030], [2040, 2040], [2050, 2050]]
  end

  def all_sectors_but_transportation
    @all_sectors_but_transportation ||= @sectors.reject{|s| s.name == 'Transportation'}
  end

  def bau
    @bau ||= @scenarios.find &:bau
  end

  def c
    @config ||= Configuration.new
  end


end