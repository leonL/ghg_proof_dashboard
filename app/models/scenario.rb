class Scenario < ActiveRecord::Base

  has_many :ghg_emissions
  has_many :plotly_charts
  belongs_to :colour

  def colour_hex_code
    colour.hex
  end

  def self.preload_colours(scenarios)
    preloader.preload(scenarios, :colour)
  end

private

  def self.preloader
    ActiveRecord::Associations::Preloader.new
  end

end