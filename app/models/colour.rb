class Colour < ActiveRecord::Base

  def self.for_palette(palette)
    where(palette: palette)
  end

  def self.preload_for(records)
    preloader.preload(records, :colour)
    return nil
  end

  def darker_hex(amount=0.4)
    hex_color = hex.gsub('#','')
    rgb = hex_color.scan(/../).map {|color| color.hex}
    rgb[0] = (rgb[0].to_i * amount).round
    rgb[1] = (rgb[1].to_i * amount).round
    rgb[2] = (rgb[2].to_i * amount).round
    "#%02x%02x%02x" % rgb
  end

  # Amount should be a decimal between 0 and 1. Higher means lighter
  def lighter_hex(amount=0.3)
    hex_color = hex.gsub('#','')
    rgb = hex_color.scan(/../).map {|color| color.hex}
    rgb[0] = [(rgb[0].to_i + 255 * amount).round, 255].min
    rgb[1] = [(rgb[1].to_i + 255 * amount).round, 255].min
    rgb[2] = [(rgb[2].to_i + 255 * amount).round, 255].min
    "#%02x%02x%02x" % rgb
  end

private

  def self.preloader
    ActiveRecord::Associations::Preloader.new
  end

end