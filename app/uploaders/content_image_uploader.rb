class ContentImageUploader < ImageUploader
  version :medium do
    process resize_to_limit: [720, 0]
    process :flatten_alpha
    process quality: 70
    process convert: :jpg
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
