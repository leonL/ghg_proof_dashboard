class CreateEnergyFlowTotals < ActiveRecord::Migration
  def change
    create_table :energy_flow_totals do |t|
      t.integer :scenario_id
      t.integer :source_id
      t.string :source_type
      t.integer :target_id
      t.string :target_type
      t.integer :year
      t.decimal :total
    end
  end
end
