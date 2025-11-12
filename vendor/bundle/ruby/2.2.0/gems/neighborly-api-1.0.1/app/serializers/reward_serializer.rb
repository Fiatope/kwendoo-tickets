class RewardSerializer < ActiveModel::Serializer
  attributes :id,
    :project_id,
    :minimum_value,
    :maximum_contributions,
    :description,
    :created_at,
    :updated_at,
    :row_order,
    :days_to_delivery,
    :soon,
    :title
end
