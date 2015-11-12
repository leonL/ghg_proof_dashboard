class EnergyTotal < ActiveRecord::Base

  belongs_to :scenario
  belongs_to :fuel_type
  belongs_to :sector
  belongs_to :zone, class_name: 'CensusTract', foreign_key: :zone_id, inverse_of: :energy_totals
end