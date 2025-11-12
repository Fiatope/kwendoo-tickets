class ChannelSerializer < ActiveModel::Serializer
  has_one :user

  def url
    neighborly_api.channel_url(object.id)
  end

  def html_url
    main_app.channels_profile_url(object, subdomain: object.permalink)
  end

  attributes :id,
   :name,
   :description,
   :permalink,
   :created_at,
   :updated_at,
   :image,
   :video_embed_url,
   :video_url,
   :how_it_works,
   :how_it_works_html,
   :terms_url,
   :state,
   :user_id,
   :accepts_projects,
   :submit_your_project_text,
   :submit_your_project_text_html,
   :start_content,
   :start_hero_image,
   :success_content,
   :url,
   :html_url
end
