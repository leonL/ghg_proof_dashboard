class CreateEnergyUseTotalsByZoneSectorFuel < ActiveRecord::Migration
  def change
    create_table :energy_use_totals_by_zone_sector_fuel do |t|
      t.integer :scenario_id
      t.integer :zone_id
      t.integer :year
      t.decimal :total
      t.integer :sector_id
      t.integer :fuel_type_id
    end
  end
end
