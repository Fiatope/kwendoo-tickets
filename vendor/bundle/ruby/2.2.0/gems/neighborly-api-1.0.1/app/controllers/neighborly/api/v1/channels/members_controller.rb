module Neighborly::Api
  module V1
    class Channels::MembersController < BaseController
      before_action :require_admin!

      def index
        respond_with parent.members, root: 'users'
      end

      def create
        channel_member = parent.channel_members.build(
          user_id: params[:channel_member].try(:[], :user_id)
        )
        if channel_member.save
          render json: channel_member.user, status: :created
        else
          respond_with channel_member
        end
      end

      def destroy
        parent.channel_members.find_by(user_id: params[:id]).delete
        head :no_content
      end

      private

      def parent
        @channel ||= Channel.find(params[:channel_id])
      end
    end
  end
end
