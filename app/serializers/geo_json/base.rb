class GeoJSON::Base

  def self.rgeo
    RGeo::GeoJSON
  end

  def self.factory
    rgeo::EntityFactory.instance
  end


end