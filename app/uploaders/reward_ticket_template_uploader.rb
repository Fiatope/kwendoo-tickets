class RewardTicketTemplateUploader < ImageUploader
  process :flatten_alpha
  process convert: :jpg

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