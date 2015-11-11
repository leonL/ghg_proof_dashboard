class CreateEmissionsSummaries < ActiveRecord::Migration
  def change
    create_table :emissions_summaries do |t|
      t.string :benchmark_type
      t.integer :scenario_id
      t.integer :benchmark_year
      t.decimal :total_change_Mt
      t.decimal :per_capita_change_t
      t.decimal :percent_change
      t.decimal :percent_per_capita_change
    end
  end
end
