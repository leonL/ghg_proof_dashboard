class AgeGroup < ActiveRecord::Base
  has_many :population_totals_by_age_group, class_name: 'PopulationTotalByAgeGroup', inverse_of: :age_group

  belongs_to :colour
end