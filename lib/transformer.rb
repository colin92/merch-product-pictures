require 'rmagick'

module MerchProductPictures
  class Transformer

    def self.transform(type, file_path)
      # Load original design
      design = Magick::Image.read(file_path).first
      design.resize! 1000, 1000, Magick::LanczosFilter

      base_layer = Magick::Image.read(File.expand_path('mockups/pillow/pillow_base_layer.png', '.')).first
      shadow_layer = Magick::Image.read(File.expand_path('mockups/pillow/pillow_shadow_layer.png', '.')).first
      texture_layer = Magick::Image.read(File.expand_path('mockups/pillow/pillow_texture_layer.png', '.')).first

      # Now we got everthing loaded
      # Let's compose!
      3.times do
        base_layer.composite!(
          design,
          (1600 - design.columns) / 2,
          (1067 - design.rows) / 2,
          Magick::OverCompositeOp
        )
      end
      base_layer.composite!(
        texture_layer, 
        0, 0, Magick::OverCompositeOp
      )
      base_layer.composite!(
        shadow_layer,
        0, 0, Magick::OverCompositeOp
      )

      base_layer.write(file_path)
    end

  end
end
