class ChannelMemberSerializer < ActiveModel::Serializer
  attributes :id,
    :channel_id,
    :user_id,
    :created_at,
    :updated_at
end
