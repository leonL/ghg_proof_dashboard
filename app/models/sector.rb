class Sector < ActiveRecord::Base

  has_many :ghg_emissions
  belongs_to :colour

  def self.find_by_name(name)
    find_by(name: name)
  end
end