class PlotlyChart < ActiveRecord::Base
  include ClassyEnum::ActiveRecord

  before_create :create_chart

  classy_enum_attr :chart_name, class_name: 'PlotlyChartBuilder'

  def self.named(name)
    where(chart_name: name).first
  end

  def create_chart
    self.attributes = chart_name.create_chart
  end
end