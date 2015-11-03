class AddColourIdToEmissionsDimensions < ActiveRecord::Migration
  def change
    add_column :fuel_types, :colour_id, :integer
    add_column :sectors, :colour_id, :integer
  end
end
