class FuelType < ActiveRecord::Base

  has_many :ghg_emissions
  belongs_to :colour

end