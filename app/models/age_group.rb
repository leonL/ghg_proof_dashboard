class AgeGroup < ActiveRecord::Base
  has_many :population_totals_by_age_group, class_name: 'PopulationTotalByAgeGroup', inverse_of: :age_group

  belongs_to :colour

  def area_chart_fill_colour_hex
    colour.lighter_hex 0.3
  end
end