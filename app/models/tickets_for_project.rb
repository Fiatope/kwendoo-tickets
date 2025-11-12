class TicketsForProject
  include ActiveModel::Serialization
  include Enumerable

  attr_accessor :project

  def initialize(project)
    @project = project
  end

  def to_csv
    attributes = [
      'token',
      'under_name'
    ]

    CSV.generate(headers: true) do |csv|
      csv << attributes.map{ |attr| I18n.t "models.ticket_for_project.#{attr}" }

      Ticket.list_of_tickets(project).each do |ticket|
        csv << attributes.map do |attr|
          if attr == 'under_name'
            ticket.name
          else
            ticket.send(attr)
          end
        end
      end
    end
  end
end
