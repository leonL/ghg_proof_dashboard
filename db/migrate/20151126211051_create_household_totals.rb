class CreateHouseholdTotals < ActiveRecord::Migration
  def change
    create_table :household_totals do |t|
      t.integer :population_context_id
      t.integer :year
      t.decimal :total
    end
  end
end
