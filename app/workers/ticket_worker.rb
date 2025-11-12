class TicketWorker
  include Sidekiq::Worker
  include REXML
  sidekiq_options retry: 5

  def perform(ticket_id)
    ticket = Ticket.find(ticket_id)
    project = ticket.ticket_categories_order.present? ? ticket.ticket_categories_order.reward.reward_category.project : ticket.reward.reward_category.project
    reward = ticket.ticket_categories_order.present? ? ticket.ticket_categories_order.reward : ticket.reward
    database = "#{project.name.strip.downcase.parameterize}-#{project.id}"

    uri = URI ENV['CODEREADR_URL']

    params = {
        :section => ENV['CODEREADR_SECTION'],
        :action => 'upsertvalue',
        :api_key => ENV['CODEREADR_API_KEY'],
        :database_id => retrieve_database(database),
        :value => ticket.token,
        :response => "#{ticket.name} (#{reward.reward_category.name} - #{reward.title})"
    }

    uri.query = URI.encode_www_form params

    res = Net::HTTP.get_response uri
  end

  def retrieve_database(database)
    uri = URI ENV['CODEREADR_URL']

    params = {
        :section => ENV['CODEREADR_SECTION'],
        :action => 'retrieve',
        :api_key => ENV['CODEREADR_API_KEY']
    }

    uri.query = URI.encode_www_form params

    res = Net::HTTP.get_response uri

    xmldoc = Document.new res.body

    ids = []
    names = []

    xmldoc.elements.each("xml/status") do |e|
      if e.text == '1'
        xmldoc.elements.each("xml/database") do |f|
          ids << f.attributes["id"]
        end
    
        xmldoc.elements.each("xml/database/name") do |f|
            names << f.text
        end
      end
    end

    id = names.index(database)

    if id.nil?
      id = create_database(database)
    else
      id = ids[id]
    end

    id
  end

  def create_database(database)
    uri = URI ENV['CODEREADR_URL']

    params = {
        :section => ENV['CODEREADR_SECTION'],
        :action => 'create',
        :api_key => ENV['CODEREADR_API_KEY'],
        :database_name => database
    }

    uri.query = URI.encode_www_form params

    res = Net::HTTP.get_response uri

    xmldoc = Document.new res.body

    id = nil

    xmldoc.elements.each("xml/status") do |e|
      if e.text == '1'
        xmldoc.elements.each("xml/id") do |f|
          id = f.text
        end
      end
    end

    id
  end
end
