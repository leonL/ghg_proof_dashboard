class ThemePresenter

  attr_reader :plotly_charts

  def load_plotly_charts(*names)
    @plotly_charts = PlotlyChart.where(chart_name: names)
  end

  def find_plotly_charts_by_name(chart_name)
    plotly_charts.find_all{|pc| pc.chart_name == chart_name }
  end

  def method_missing(name)
    name = name.to_s
    plotly_chart_names.include?(name.to_s) ? find_plotly_charts_by_name(name) : raise(NoMethodError)
  end

  def all_scenarios
    @scenarios ||= Scenario.all
  end

  def find_scenario_by(param = {id: nil})
    param = param.first
    all_scenarios.find do |s|
      s.send(param.first) == param.last
    end
  end

  def bau
    @bau_scenario ||= all_scenarios.find &:bau
  end

  def all_colours
    @colours ||= Colour.all
  end

  def find_colour_by_id(id)
    all_colours.find{|c| c.id == id}
  end

  def all_scenarios_with_colour_json
    hash = all_scenarios.map do |s|
      {
        id: s.id,
        name: s.name,
        bau: s.bau,
        colour: {
          id: s.colour_id,
          hex: find_colour_by_id(s.colour_id).hex
        }
      }
    end
    hash.to_json
  end

end

Dir[File.join(Rails.root, 'app', 'presenters', 'theme_presenter', '*.rb')].each{ |file| require_dependency file }