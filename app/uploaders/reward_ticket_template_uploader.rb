class RewardTicketTemplateUploader < ImageUploader
  # Accept only raster image formats (inherits extension_white_list from ImageUploader:
  # jpg, jpeg, gif, png). SVG and other vectors are blocked upstream.

  # Defense in depth: cap at 5 MB. The parent form is multipart, Rack/Puma can
  # happily swallow huge files otherwise.
  def size_range
    1.byte..5.megabytes
  end

  # Normalise transparent PNGs against a white background so the final JPEG
  # does not show black zones where the alpha channel was.
  process :flatten_alpha
  process convert: :jpg

  def flatten_alpha
    manipulate! do |img|
      img.combine_options do |c|
        c.background 'white'
        c.flatten
      end
      img
    end
  end
end