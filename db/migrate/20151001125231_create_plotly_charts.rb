class CreatePlotlyCharts < ActiveRecord::Migration
  def change
    create_table :plotly_charts do |t|
      t.string :plotly_user
      t.integer :plotly_id
      t.string :chart_type
      t.string :chart_name
    end
  end
end
