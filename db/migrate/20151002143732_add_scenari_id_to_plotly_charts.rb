class AddScenariIdToPlotlyCharts < ActiveRecord::Migration
  def change
    change_table :plotly_charts do |t|
      t.integer :scenario_id, default: nil
    end
  end
end
