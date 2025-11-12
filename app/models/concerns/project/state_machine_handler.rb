module Project::StateMachineHandler
  extend ActiveSupport::Concern

  included do
     state_machine :campaign_type, initial: :flexible do
      state :flexible
    end

    state_machine :state, initial: :online do
      state :draft
      state :soon
      state :rejected
      state :online
      state :successful
      state :finished
      state :waiting_funds
      state :request_funds
      state :fraud_suspiscion
      state :paid
      state :failed
      state :deleted

      event :push_to_draft do
        transition all => :draft #NOTE: when use 'all' we can't use new hash style ;(
      end

      event :approve do
        transition [:draft, :rejected] => :soon
      end

      event :push_to_trash do
        transition [:draft, :rejected] => :deleted
      end

      event :reject do
        transition [:draft] =>  :rejected
      end

      event :launch do
        transition [:draft, :soon] => :online
      end

      event :push_to_request_funds do
        transition [:online, :draft, :succesful, :waiting_funds, :failed] => :request_funds #NOTE: when use 'all' we can't use new hash style ;(
      end

      event :push_to_fraud_suspiscion do
        transition [:online, :draft, :succesful, :waiting_funds, :failed] => :fraud_suspiscion #NOTE: when use 'all' we can't use new hash style ;(
      end

      event :push_to_paid do
        transition [:request_funds] => :paid
      end
 
      event :finish do
        transition online: :failed,               if: ->(project) {
          !project.flexible? && project.expired? && !project.pending_contributions_reached_the_goal?
        }

        transition online: :waiting_funds,        if: ->(project) {
          project.expired? && (project.pending_contributions_reached_the_goal? || project.flexible?)
        }

        transition waiting_funds: :successful,    if: ->(project) {
          project.reached_goal? && !project.in_time_to_wait? && project.goal?
        }

	transition draft: :online,	if: ->(project) {
	}

	transition online: :finished,	if: ->(project) {
	  project.expired?
	}

        transition waiting_funds: :failed,        if: ->(project) {
          !project.flexible? && project.expired? && !project.reached_goal? && !project.in_time_to_wait?
        }

        transition waiting_funds: :waiting_funds, if: ->(project) {
          project.expired? && !project.reached_goal? && (project.in_time_to_wait?)
        }
      end

      after_transition do |project, transition|
        project.notify_observers :"from_#{transition.from}_to_#{transition.to}"
      end

      after_transition any => [:failed, :successful] do |project, transition|
        project.notify_observers :sync_with_mailchimp
      end

      after_transition [:draft, :rejected] => :deleted do |project, transition|
        project.update({ permalink: "deleted_project_#{project.id}"})
      end
    end
  end
end
