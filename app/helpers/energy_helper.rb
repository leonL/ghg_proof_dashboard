module EnergyHelper

  def energy_changes_grouped_by_benchmark_type
    @energy_changes_grouped ||= @energy_summaries.group_by(&:benchmark_type)
  end
end