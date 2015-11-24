class Scenario < ActiveRecord::Base

  has_many :ghg_emissions
  has_many :energy_totals
  has_many :energy_use_totals_by_zone_sector_fuel, class_name: 'EnergyUseTotalByZoneSectorFuel'
  has_many :plotly_charts
  has_many :emissions_reduction_summaries
  belongs_to :colour

  def colour_hex_code
    colour.hex
  end

end