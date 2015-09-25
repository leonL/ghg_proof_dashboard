class CreateCensusTracts < ActiveRecord::Migration
  def change
    create_table :census_tracts do |t|
      t.integer :zone_id
      t.decimal :area
      t.multi_polygon :geom, srid: 4326
      t.timestamps
    end

    change_table :census_tracts do |t|
      t.index :geom, using: :gist
    end
  end
end
