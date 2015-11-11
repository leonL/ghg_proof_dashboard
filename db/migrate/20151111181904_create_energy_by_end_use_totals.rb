class CreateEnergyByEndUseTotals < ActiveRecord::Migration
  def change
    create_table :energy_by_end_use_totals do |t|
      t.integer :scenario_id
      t.integer :year
      t.decimal :total
      t.integer :end_use_id
      t.integer :fuel_type_id
    end
  end
end
