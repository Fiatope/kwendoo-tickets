module Neighborly::Api
  module V1
    class ProjectsController < Neighborly::Api::BaseController
      include PaginatedController

      has_scope :order_by
      has_scope :pg_search, as: :query
      has_scope :between_created_at,
        :between_expires_at,
        :between_online_date,
        using: %i(starts_at ends_at),
        type:  :hash

      def index
        respond_with_pagination collection
      end

      def show
        project = ::Project.find(params[:id])
        authorize project
        respond_with project, serializer: Neighborly::Api::ProjectSerializer
      end

      def update
        @project = Project.find(params[:id])
        authorize @project
        respond_with Project.update(params[:id], permitted_params)
      end

      def destroy
        project = Project.find(params[:id])
        authorize project

        project.push_to_trash!
        head :no_content
      end

      [:approve, :launch, :reject, :push_to_draft].each do |name|
        define_method name do
          project = Project.find(params[:id])
          authorize project

          project.send("#{name.to_s}!")
          head :no_content
        end
      end

      private

      def permitted_params
        params.permit(policy(@project || Project).permitted_attributes)[:project]
      end

      def collection
        @collection ||= begin
          if ActiveRecord::ConnectionAdapters::Column.
              value_to_boolean(params[:manageable])
            authorized_scope = policy_scope(Neighborly::Api::Project)
          else
            authorized_scope = Neighborly::Api::Project.visible
          end
          apply_scopes(scoped_by_state(authorized_scope)).without_state('deleted')
        end
      end

      def scoped_by_state(scope)
        state_scopes = params.slice(*Project.state_names).keys
        if state_scopes.any?
          scope.with_state(state_scopes)
        else
          scope
        end
      end
    end
  end
end
