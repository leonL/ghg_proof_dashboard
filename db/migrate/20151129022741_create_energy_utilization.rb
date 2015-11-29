class CreateEnergyUtilization < ActiveRecord::Migration
  def change
    create_table :energy_utilizations do |t|
      t.string :name
      t.integer :colour_id
    end
  end
end
