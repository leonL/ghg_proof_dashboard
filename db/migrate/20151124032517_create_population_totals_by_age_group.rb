class CreatePopulationTotalsByAgeGroup < ActiveRecord::Migration
  def change
    create_table :population_totals_by_age_group do |t|
      t.integer :population_context_id
      t.integer :year
      t.decimal :total
      t.integer :age_group_id
    end
  end
end
