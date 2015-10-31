class CreateColours < ActiveRecord::Migration
  def change
    create_table :colours do |t|
      t.string :hex
      t.string :palette
    end
  end
end
