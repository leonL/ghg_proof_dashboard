class CreateEndUses < ActiveRecord::Migration
  def change
    create_table :end_uses do |t|
      t.string :name
      t.integer :colour_id
    end
  end
end
