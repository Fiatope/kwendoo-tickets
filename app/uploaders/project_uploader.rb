class ProjectUploader < ImageUploader
  process :flatten_alpha
  process convert: :jpg

  version :project_thumb do
    process resize_to_fill: [228,178]
  end

  version :project_thumb_small, from_version: :project_thumb do
    process resize_to_fill: [85,67]
  end

  version :project_thumb_large do
    process resize_to_fill: [495,335]
  end

  #facebook requires a minimum thumb size
  version :project_thumb_facebook do
    process resize_to_fill: [512,400]
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
