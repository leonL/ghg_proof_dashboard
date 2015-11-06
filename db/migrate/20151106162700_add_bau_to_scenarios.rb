class AddBauToScenarios < ActiveRecord::Migration
  def change
    add_column :scenarios, :bau, :boolean
  end
end
