class EnergyFlowTotal < ActiveRecord::Base

  belongs_to :scenario
  belongs_to :source, polymorphic: true
  belongs_to :target, polymorphic: true

end