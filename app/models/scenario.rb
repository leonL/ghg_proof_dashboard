class Scenario < ActiveRecord::Base

  has_many :ghg_emissions
  has_many :plotly_charts

end