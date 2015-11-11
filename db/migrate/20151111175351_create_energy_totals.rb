class CreateEnergyTotals < ActiveRecord::Migration
  def change
    create_table :energy_totals do |t|
      t.integer :scenario_id
      t.integer :zone_id
      t.integer :year
      t.decimal :total
      t.integer :sector_id
      t.integer :fuel_type_id
    end
  end
end
