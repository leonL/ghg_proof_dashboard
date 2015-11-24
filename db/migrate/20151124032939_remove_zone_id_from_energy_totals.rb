class RemoveZoneIdFromEnergyTotals < ActiveRecord::Migration
  def change
    remove_column :energy_totals, :zone_id, :integer
  end
end
