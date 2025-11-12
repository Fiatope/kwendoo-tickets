class UserSerializer < ActiveModel::Serializer
  def created_at
    object.created_at.to_datetime.utc.rfc3339
  end

  def name
    object.display_name
  end

  def image_url
    object.display_image
  end

  def total_contributed
    object.user_total ? object.user_total.sum : 0
  end

  def url
    neighborly_api.user_url(object.id)
  end

  def html_url
    main_app.user_url(object)
  end

  def manager
    (object.admin? || object.channel.present? || object.channels.any?)
  end

  attributes :id,
    :bio,
    :created_at,
    :email,
    :facebook_url,
    :linkedin_url,
    :other_url,
    :profile_type,
    :twitter_url,
    :name,
    :image_url,
    :total_contributed,
    :admin,
    :url,
    :html_url,
    :manager
end
