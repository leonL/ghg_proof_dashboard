class PlotlyChartBuilder::EmissionsBySector < PlotlyChartBuilder

  def args
    plot_coordinates = []
    all_factor_values.each do |factor|
      plot_coordinates << {
        x: all_x_values_by_factor[factor]
        y: all_y_values
        fill: 'tonexty'
      }
    end
    plot_coordinates
  end

  def kwargs
    super.merge(
      {
        fileopt: 'overwrite',
        style: { type: 'scatter' },
        layout: {
          title: 'Emissions By Sector'
        }
      }
    )
  end

# plot coordinate mapping logic

  def all_x_values_by_factor
    @vals ||= begin do
      x_vals = hash_of_arrays

      all_y_values.each do |y_val|
        totals_by_factor = totals_by_factor_for_y(y_val)
        running_y_total = 0

        all_factor_values.each do |factor|
          factor_hash = totals_by_factor[factor].first
          total = (factor_hash ? factor_hash.total : 0)
          x_vals[factor] << (running_y_total += total)
        end
      end
      x_vals
    end
  end

  def totals_by_factor_for_y(y_val)
    totals_by_y_value[y_val].group_by(&factor)
  end

  def totals
    @totals ||= GhgEmission.total_emissions_grouped_by_where(factor, y_axis_unit, scenario_id)
  end

  def totals_by_y_value
    @totals_by_y ||= totals.group_by(&y_axis_unit)
  end

  def all_factor_values
    @all_factors ||= totals.uniq(&:sector_id).map(&:sector_id)
  end

  def all_y_values
    @all_y_vals = totals_by_y_values.keys.sort
  end

# constants variables
private

  def y_axis_unit
    :year
  end

  def factor
    :sector_id
  end

# util

  def hash_of_arrays # should be a class level method
    Hash.new{|h,k| h[k] = [] }
  end

end