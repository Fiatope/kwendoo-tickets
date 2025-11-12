module Neighborly::Api
  class ProjectSerializer < ActiveModel::Serializer
    has_one :user

    def created_at
      object.created_at.to_datetime.utc.rfc3339
    end

    def expires_at
      value = object.expires_at
      if value
        value.to_datetime.utc.rfc3339
      end
    end

    def online_date
      value = object.online_date
      if value
        value.to_datetime.utc.rfc3339
      end
    end

    def channel_id
      object.last_channel.try(:id)
    end

    def rights
      {
        can_approve: object.can_approve?,
        can_launch: object.can_launch?,
        can_reject: object.can_reject?,
        can_push_to_draft: object.can_push_to_draft?,
        can_push_to_trash: object.can_push_to_trash?
      }
    end

    def url
      neighborly_api.project_url(object.id)
    end

    def html_url
      main_app.project_url(object)
    end

    attributes :id,
      :about,
      :about_html,
      :address_city,
      :address_neighborhood,
      :address_state,
      :address_zip_code,
      :budget,
      :budget_html,
      :campaign_type,
      :category_id,
      :created_at,
      :expires_at,
      :featured,
      :goal,
      :hash_tag,
      :headline,
      :hero_image,
      :home_page,
      :name,
      :online_date,
      :online_days,
      :organization_type,
      :permalink,
      :pledged,
      :recommended,
      :short_url,
      :site,
      :state,
      :street_address,
      :terms,
      :terms_html,
      :uploaded_image,
      :video_embed_url,
      :video_thumbnail,
      :video_url,
      :channel_id,
      :rights,
      :url,
      :html_url
  end
end
