module Neighborly::Balanced
  class OrderProxy
    I18N_SCOPE = 'neighborly.balanced.order'

    delegate :user, to: :project
    delegate :amount, :amount_escrowed, :debit_from, :description, :meta,
      :reload, :save, to: :order

    attr_reader :project

    def initialize(project)
      @project = project
    end

    private

    def order
      @order ||= if order_href
        ::Balanced::Order.find(order_href)
      else
        create_order
      end
    end

    def order_href
      @order_href ||= Order.find_by(project_id: project).try(:href)
    end

    def create_order
      subject = Customer.new(user, {}).fetch.create_order
      Order.create!(href: subject.href, project: project)

      subject.description = I18n.t('description',
        project_id:   project.id,
        project_name: project.name,
        scope:        I18N_SCOPE
      )

      project_url = Rails.application.routes.url_helpers.project_url(project)
      subject.meta = {
        'Project'       => project.name,
        'Goal'          => project.goal,
        'Campaign Type' => project.campaign_type.humanize,
        'User'          => project.user.name,
        'Category'      => project.category.name_en,
        'URL'           => project_url,
        'Expires At'    => I18n.l(project.expires_at),
        'ID'            => project.id,
      }
      subject.save

      subject
    end
  end
end
