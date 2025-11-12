module Neighborly::Api
  module V1
    class TagsController < BaseController
      before_action :require_admin!, except: %i(index show)

      include PaginatedController

      has_scope :popular, type: :boolean

      def index
        respond_with_pagination apply_scopes(Tag).all
      end

      def create
        respond_with Tag.create(permited_params)
      end

      def update
        respond_with Tag.update(params[:id], permited_params)
      end

      def show
        respond_with Tag.find(params[:id])
      end

      def destroy
        respond_with Tag.destroy(params[:id])
      end

      private

      def permited_params
        params.permit({ tag: [ :name, :visible ] })[:tag]
      end
    end
  end
end
