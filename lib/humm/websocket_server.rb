class Humm::WebsocketServer
  
  def self.run!(opts)
    EventMachine::WebSocket.start :host => opts[:host], :port => opts[:port] do |ws|
      
      ws.onopen do
        Humm::Channels.add_client ws
      end
      
      ws.onclose do
        Humm::Channels.remove_client ws
      end
      
    end
  end
  
end