class CreateEmissionsReductionSummaries < ActiveRecord::Migration
  def change
    create_table :emissions_reduction_summaries do |t|
      t.integer :benchmark_year
      t.string :benchmark_type
      t.integer :scenario_id
      t.decimal :total_Mt
      t.decimal :percent
      t.decimal :per_capita_t
      t.decimal :percent_per_capita
    end
  end
end
