class PlotlyChartBuilder::EnergyByFactor < PlotlyChartBuilder

# value querying logic

  def self.yearly_energy_use_grouped_by_scenario
    @use_by_scenario ||= begin
      EnergyTotal.yearly_totals_by_factors([factor_symbol, :scenario]).
        group_by(&:scenario_id)
    end
  end

  def totals
    self.class.yearly_energy_use_grouped_by_scenario[scenario_id]
  end

# args hash and related logic

  def args
    plot_coordinates = []
    all_factor_records.each do |factor|
      formatted_y_vals = y_vals_grouped_by_factor_id_sequenced[:formatted_values][factor.id]
      next if formatted_y_vals.uniq.count == 1 && formatted_y_vals.uniq.first == 0
      plot_coordinates << {
        x: all_years,
        y: y_vals_grouped_by_factor_id_sequenced[:cumulative_values][factor.id],
        text: formatted_y_vals,
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
    @all_years = totals_grouped_by_year.keys.sort
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
          vals[factor.id] << total.round(2)
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
          title: 'PJ',
          titlefont: {
            family: "Arial, sans-serif",
            size: 12,
            color: "black"
          },
          range: [0, 15],
          ticks: '',
          dtick: 5,
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

  Dir[File.join(Rails.root, 'app', 'enums', 'plotly_chart_builder', 'energy_by_factor', '*.rb')].each{ |file| require_dependency file }

end