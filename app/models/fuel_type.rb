class FuelType < ActiveRecord::Base

  has_many :ghg_emissions

end