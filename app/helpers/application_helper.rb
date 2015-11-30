module ApplicationHelper

  def scenarios
    @scenarios ||= Scenario.includes(:colour)
  end

  def bau
    @bau ||= scenarios.find &:bau
  end

  def end_uses
    @end_uses ||= EndUse.all
  end

  def age_groups
    @age_groups ||= AgeGroup.all
  end

  def c
    @config ||= Configuration.new
  end

  def select_options_for_year
    [[2011, 2011], [2020, 2020], [2030, 2030], [2040, 2040], [2050, 2050]]
  end

  def select_options_for_factor(factor, all_option=true)
    scenario_names_and_ids = factor.map do |scenario|
      [scenario.name, scenario.id]
    end
    scenario_names_and_ids.unshift ['All', 0] if all_option
    options_for_select(scenario_names_and_ids, scenario_names_and_ids.first.last)
  end
end
