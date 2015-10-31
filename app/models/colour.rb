class Colour < ActiveRecord::Base

  def self.for_palette(palette)
    where(palette: palette)
  end

end