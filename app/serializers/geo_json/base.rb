class GeoJSON::Base

  def self.rgeo
    RGeo::GeoJSON
  end

  def self.factory
    rgeo::EntityFactory.instance
  end

  def self.year_range
    [GhgEmission.minimum(:year), GhgEmission.maximum(:year)]
  end


end