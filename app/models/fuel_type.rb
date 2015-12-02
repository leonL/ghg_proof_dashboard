class FuelType < ActiveRecord::Base

  has_many :ghg_emissions
  has_many :energy_totals
  has_many :energy_use_totals_by_zone_sector_fuel, class_name: 'EnergyUseTotalByZoneSectorFuel'
  has_many :energy_flow_totals_as_source, as: :source, class_name: 'EnergyFlowTotal'
  has_many :energy_flow_totals_as_target, as: :target, class_name: 'EnergyFlowTotal'
  belongs_to :colour

end