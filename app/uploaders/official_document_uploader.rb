class OfficialDocumentUploader < ImageUploader
  process convert: :jpg

  version :thumb_official_document do
    process quality: 100
    process resize_to_fill: [150, 150]
  end

end
