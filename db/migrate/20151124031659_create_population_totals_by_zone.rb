class CreatePopulationTotalsByZone < ActiveRecord::Migration
  def change
    create_table :population_totals_by_zone do |t|
      t.integer :population_context_id
      t.integer :zone_id
      t.integer :year
      t.decimal :total
    end
  end
end
