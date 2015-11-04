class Scenario < ActiveRecord::Base

  has_many :ghg_emissions
  has_many :plotly_charts
  has_many :emissions_reduction_summaries
  belongs_to :colour

  def colour_hex_code
    colour.hex
  end

end