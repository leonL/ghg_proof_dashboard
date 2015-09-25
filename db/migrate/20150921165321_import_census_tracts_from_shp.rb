class ImportCensusTractsFromShp < ActiveRecord::Migration
  def up
    from_shp_sql = `shp2pgsql -c -g geom -W LATIN1 -s 92958:4326 #{Rails.root}/db/shpfiles/census_tracts/toronto_ct1.shp census_tracts_ref`

    CensusTract.transaction do
      execute <<-SQL
        INSERT into spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext) values ( 92958, 'epsg', 2958, '+proj=utm +zone=17 +ellps=GRS80 +units=m +no_defs ', 'PROJCS["NAD83(CSRS) / UTM zone 17N",GEOGCS["NAD83(CSRS)",DATUM["NAD83_Canadian_Spatial_Reference_System",SPHEROID["GRS 1980",6378137,298.257222101,AUTHORITY["EPSG","7019"]],AUTHORITY["EPSG","6140"]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.01745329251994328,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4617"]],UNIT["metre",1,AUTHORITY["EPSG","9001"]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",0],PARAMETER["central_meridian",-81],PARAMETER["scale_factor",0.9996],PARAMETER["false_easting",500000],PARAMETER["false_northing",0],AUTHORITY["EPSG","2958"],AXIS["Easting",EAST],AXIS["Northing",NORTH]]');
      SQL

      execute from_shp_sql

      execute <<-SQL
        insert into census_tracts(zone_id, area, geom)
          select zoneid, area, geom from census_tracts_ref
      SQL

      drop_table :census_tracts_ref
    end

  end

  def down
    CensusTract.delete_all
  end
end
