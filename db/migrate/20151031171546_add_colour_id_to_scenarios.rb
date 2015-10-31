class AddColourIdToScenarios < ActiveRecord::Migration
  def change
    add_column :scenarios, :colour_id, :integer
  end
end
