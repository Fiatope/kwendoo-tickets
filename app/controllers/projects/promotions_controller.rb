class Projects::PromotionsController < ApplicationController
    after_action :verify_authorized, except: :index
    inherit_resources
  
    def new
        @project      = parent
        @promotion = Promotion.new(project: parent)
        authorize @promotion
    end

    def create
        # Create promotion. Currency is initialized in local currency (not EUR).
        @project      = parent
        @promotion = Promotion.new(permitted_params[:promotion].
                                        merge(project: parent))
        authorize @promotion

        if @promotion.save
            redirect_to promotions_project_path(@project)
        else
            flash.alert = t('controllers.projects.promotions.create.error')
            render "new"
        end
    end

    def edit
        @project      = parent
        @promotion = resource
        authorize @promotion
        @rewards = @project.rewards
        @selected_rewards = @promotion.rewards.map(&:id)
    end

    def update
        # Create promotion. Currency is initialized in local currency (not EUR).
        @project      = parent
        @promotion = resource
        authorize @promotion

        permitted_promotion = permitted_params[:promotion].to_unsafe_h

        if permitted_promotion[:reward]
            permitted_promotion[:reward].each do |reward|
                PromotionReward.find_or_create_by(promotion_id: @promotion.id, reward_id: reward)
            end

            PromotionReward.where(promotion_id: @promotion.id).where.not(reward_id: permitted_promotion[:reward]).destroy_all

            permitted_promotion.delete(:reward)
        else
            PromotionReward.where(promotion_id: @promotion.id).destroy_all
        end

        if @promotion.update(permitted_promotion)
            redirect_to promotions_project_path(@project)
        else
            flash.alert = t('controllers.projects.promotions.create.error')
            render "new"
        end
    end

    protected

    def permitted_params
      params.permit(policy(@promotion || Promotion).permitted_attributes)
    end
  
    def collection
      @promotions ||= apply_scopes(parent.promotions).available_to_display.where(matching_id: nil).order("confirmed_at DESC").per(10)
    end

    def parent
      @parent ||= Project.find_by_permalink!(params[:project_id])
    end
  
    def resource
      @resource ||= parent.promotions.find(params[:id])
    end
end
