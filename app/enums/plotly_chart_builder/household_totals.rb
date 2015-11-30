class PlotlyChartBuilder::HouseholdTotals < PlotlyChartBuilder
  include ActionView::Helpers::NumberHelper

# value querying logic

  def totals
    @totals ||= HouseholdTotal.order(:year)
  end

# args hash and related logic

  def args
    {
      x: all_years_sequenced,
      y: y_values_sequenced,
      text: y_values_sequenced.map{|total| number_with_precision(total, precision: 2, delimiter: ',')},
      hoverinfo: 'x+text'
    }
  end

  def all_years_sequenced
    @all_years ||= totals.map &:year
  end

  def y_values_sequenced
    @y_vals ||= totals.map &:total
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
          range: [all_years_sequenced.first, all_years_sequenced.last],
          ticks: 'outside',
          tick0: 0,
          dtick: 10,
          showline: true,
          showgrid: true,
          zeroline: false
        },
        yaxis: {
          range: [0, ceil_for_place(y_values_sequenced.max, 6)],
          ticks: '',
          dtick: 1000000,
          ticklen: 20,
          tickcolor: "rgb(255, 255, 255)",
          showline: true,
          showgrid: true,
          zeroline: false
        }
      }
    )
  end
end