class PlotlyChartBuilder::EmissionsByFactor < PlotlyChartBuilder

  def self.yearly_emissions_grouped_by_scenario
    @totals_by_scenario ||= begin
      GhgEmission.yearly_emissions_grouped_by(factor_symbol, :scenario).
        group_by(&:scenario_id)
    end
  end

  def totals
    self.class.yearly_emissions_grouped_by_scenario[scenario_id]
  end

  def args
    plot_coordinates = []
    all_factor_records.each do |factor|
      plot_coordinates << {
        x: all_x_values_grouped_by_factor[factor],
        y: all_years,
        fill: 'tonexty'
      }
    end
    plot_coordinates
  end

# plot coordinate mapping logic

  def all_years
    @all_years = totals_grouped_by_year.keys.sort
  end

  def all_x_values_grouped_by_factor
    @vals ||= begin
      x_vals = Hash.new{|h,k| h[k] = [] }

      all_years.each do |year|
        totals_by_factor = totals_grouped_by_factor_id_for_year(year)
        running_y_total = 0

        all_factor_records.each do |factor|
          factor_hash = totals_by_factor[factor.id].first
          total = (factor_hash ? factor_hash.total : 0)
          x_vals[factor.id] << (running_y_total += total)
        end
      end
      x_vals
    end
  end

  def all_factor_records
    @all_factors ||= totals.uniq(&factor_symbol_id).map(&factor_symbol)
  end

  def totals_grouped_by_year
    @totals_by_y ||= totals.group_by(&:year)
  end

  def totals_grouped_by_factor_id_for_year(year)
    totals_grouped_by_year[year].group_by(&factor_symbol_id)
  end

# util

  def self.factor_symbol
    name_snake_case.split('_').last.to_sym
  end

  delegate :factor_symbol, to: :class

  def factor_symbol_id
    with_id = factor_symbol.to_s + '_id'
    with_id.to_sym
  end

  Dir[File.join(Rails.root, 'app', 'enums', 'plotly_chart_builder', 'emissions_by_factor', '*.rb')].each{ |file| require_dependency file }

end