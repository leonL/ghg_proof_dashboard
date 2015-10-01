class PlotlyChart < ActiveRecord::Base
  include ClassyEnum::ActiveRecord

  classy_enum_attr :chart_name, class_name: 'PlotlyChartBuilder'

  delegate :create_chart, to: :chart_name
end