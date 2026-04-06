class HeroImageUploader < ImageUploader
  process :flatten_alpha
  process convert: :jpg

  version :blur do
    process resize_to_limit: [2000, 0]
    process :apply_blur
    process quality: 70
  end

  def apply_blur
    manipulate! do |img|
      img.combine_options do |c|
        c.blur "0x5"
      end
      img
    end
  end

  def flatten_alpha
    manipulate! do |img|
      img.combine_options do |c|
        c.background "white"
        c.flatten
      end
      img
    end
  end

end
