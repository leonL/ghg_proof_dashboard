class CreateGhgEmissionsTable < ActiveRecord::Migration
  def change
    create_table :ghg_emissions do |t|
      t.integer :zone_id
      t.string :sector_id
      t.string :fuel_type_id
      t.integer :scope
      t.integer :scenario_id
      t.integer :year
      t.decimal :total_emissions
    end
  end
end