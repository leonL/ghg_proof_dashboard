class PlotlyChartBuilder::PopulationByAgeGroup < PlotlyChartBuilder
  include ActionView::Helpers::NumberHelper

# value querying logic

  def totals
    @totals ||= PopulationTotalByAgeGroup.yearly_totals_by_factors([factor_symbol])
  end

# args hash and related logic

  def args
    plot_coordinates = []
    all_factor_records.each do |factor|
      plot_coordinates << {
        x: all_years,
        y: y_vals_grouped_by_factor_id_sequenced[:cumulative_values][factor.id],
        text: y_vals_grouped_by_factor_id_sequenced[:formatted_values][factor.id],
        mode: 'lines',
        type: 'scatter',
        fill: 'tonexty',
        name: factor.name,
        hoverinfo: 'x+text',
        fillcolor: factor.colour.lighter_hex,
        line: {
          color: factor.colour.hex
        }
      }
    end
    plot_coordinates
  end

  def all_years
    @all_years ||= totals_grouped_by_year.keys.sort
  end

  def y_vals_grouped_by_factor_id_sequenced
    @y_vals ||= begin
      cumulative_vals = Hash.new{|h,k| h[k] = [] }
      vals = Hash.new{|h,k| h[k] = [] }

      all_years.each do |year|
        totals_by_factor = totals_grouped_by_factor_id_for_year(year)
        running_total = 0

        all_factor_records.each do |factor|
          factor_hash = totals_by_factor[factor.id].first
          total = (factor_hash ? factor_hash.total : 0)
          cumulative_vals[factor.id] << (running_total += total)
          vals[factor.id] << number_with_precision(total.to_i, precision: 0, delimiter: ',')
        end
      end
      {
        formatted_values: vals,
        cumulative_values: cumulative_vals
      }
    end
  end

  def all_factor_records
    @all_factors ||= begin
      factors = totals.uniq(&factor_symbol_id).map(&factor_symbol)
      Colour.preload_for(factors)
      factors
    end
  end

  def totals_grouped_by_year
    @totals_by_y ||= totals.group_by(&:year)
  end

  def totals_grouped_by_factor_id_for_year(year)
    totals_grouped_by_year[year].group_by(&factor_symbol_id)
  end

# kwargs related logic

  def layout
    super.merge(
      {
        margin: {t: 10, r: 20, l: 50, b: 52},
        titlefont: {
          family: "Arial, sans-serif",
          size: 16,
          color: "black"
        },
        xaxis: {
          title: 'Year',
          titlefont: {
            family: "Arial, sans-serif",
            size: 12,
            color: "black"
          },
          range: [all_years.first, all_years.last],
          ticks: 'outside',
          tick0: 0,
          dtick: 10,
          showline: true,
          showgrid: true,
          zeroline: false
        },
        yaxis: {
          ticks: '',
          dtick: 20000,
          ticklen: 20,
          tickcolor: "rgb(255, 255, 255)",
          showline: true,
          showgrid: true,
          zeroline: false
        }
      }
    )
  end

# util

  def self.factor_symbol
    name_snake_case.split('by_').last.to_sym
  end

  delegate :factor_symbol, to: :class

  def factor_symbol_id
    with_id = factor_symbol.to_s + '_id'
    with_id.to_sym
  end
end