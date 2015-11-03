class Scenario < ActiveRecord::Base

  has_many :ghg_emissions
  has_many :plotly_charts
  belongs_to :colour

  def colour_hex_code
    colour.hex
  end

end