class FuelType < ActiveRecord::Base

  has_many :ghg_emissions
  has_many :energy_totals
  belongs_to :colour

  def area_chart_fill_colour_hex
    colour.lighter_hex 0.3
  end

end