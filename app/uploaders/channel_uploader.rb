class ChannelUploader < ImageUploader

  process :flatten_alpha
  process convert: :jpg
  process quality: 100

  version :thumb do
    process resize_and_pad: [170, 85]
  end

  version :large do
    process resize_and_pad: [300, 150]
  end

  version :x_large do
    process resize_and_pad: [600, 300]
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
