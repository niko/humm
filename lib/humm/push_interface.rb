require 'rack/cors'

module Humm::PushInterface
  def self.registered(app)
    app.use Rack::CommonLogger
    
    app.use Rack::Cors do |cfg|
      cfg.allow do |allow|
        allow.origins '*'
        allow.resource '*', :headers => :any, :methods => :post
      end
    end
    
    app.post '*' do
      halt 500, 'Push needs to have a message parameter' unless message = params[:message]
      
      channel = params[:splat].first
      puts "received message on channel #{channel}"
      
      clients = Humm::CHANNELS.path(channel).parents_content(true)
      clients.each do |connection|
        connection.send message
      end
      
      "Sent #{message} to #{clients.size} clients: #{clients.map{|c| c.request['Path']}.inspect}"
    end
  end
end
