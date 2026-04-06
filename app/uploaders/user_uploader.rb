class UserUploader < ImageUploader
  process :flatten_alpha
  process convert: :jpg

  version :thumb_avatar do
    process quality: 100
    process resize_to_fill: [150, 150]
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
