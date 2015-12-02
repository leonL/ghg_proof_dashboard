class EndUse < ActiveRecord::Base

  has_many :energy_by_end_use_totals
  belongs_to :colour
end