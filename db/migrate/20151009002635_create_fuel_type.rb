class CreateFuelType < ActiveRecord::Migration
  def change
    create_table :fuel_types do |t|
      t.string :name
    end
  end
end
