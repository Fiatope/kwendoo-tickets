class TagSerializer < ActiveModel::Serializer
  def total_projects
    object.projects.size
  end

  attributes :id,
    :name,
    :total_projects,
    :visible
end
