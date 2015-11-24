module EmissionsHelper

  def emissions_changes_grouped_by_benchmark_type
    @emissions_changes_grouped ||= @emissions_summaries.group_by(&:benchmark_type)
  end
end