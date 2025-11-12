class PressAssetSerializer < ActiveModel::Serializer
  def image_url
    object.image.thumb.url
  end

  attributes :id,
    :title,
    :image_url,
    :url,
    :created_at
end
