class EndUse < ActiveRecord::Base

  has_many :energy_by_end_use_totals
  belongs_to :colour

  def area_chart_fill_colour_hex
    colour.lighter_hex 0.3
  end

end