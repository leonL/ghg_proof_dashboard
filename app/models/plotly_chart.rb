class PlotlyChart < ActiveRecord::Base
  include ClassyEnum::ActiveRecord

  classy_enum_attr :chart_name, class_name: 'PlotlyChartBuilder'

  def create_chart
    self.attributes = chart_name.create_chart
  end
end