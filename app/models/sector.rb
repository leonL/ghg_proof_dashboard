class Sector < ActiveRecord::Base

  has_many :ghg_emissions
  has_many :energy_totals
  has_many :energy_use_totals_by_zone_sector_fuel, class_name: 'EnergyUseTotalByZoneSectorFuel'
  belongs_to :colour

  def self.find_by_name(name)
    find_by(name: name)
  end

  def area_chart_fill_colour_hex
    colour.lighter_hex 0.3
  end
end