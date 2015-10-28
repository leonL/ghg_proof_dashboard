class Sector < ActiveRecord::Base

  has_many :ghg_emissions

  def self.find_by_name(name)
    find_by(name: name)
  end
end