class CreateEnergySummaries < ActiveRecord::Migration
  def change
    create_table :energy_summaries do |t|
      t.string :benchmark_type
      t.integer :scenario_id
      t.integer :benchmark_year
      t.decimal :total_use_change_PJ
      t.decimal :per_capita_use_change_GJ
      t.decimal :percent_use_change
      t.decimal :percent_use_per_capita_change
    end
  end
end
