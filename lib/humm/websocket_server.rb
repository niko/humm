class Humm::WebsocketServer
  
  def self.run!(opts)
    EventMachine::WebSocket.start :host => opts[:host], :port => opts[:port] do |ws|
      ws.onopen do
        Humm::CHANNELS.path(ws.request['Path']) << ws
        puts "WebSocket client connected on channel #{ws.request['Path']}."
      end
      
      # ws.onmessage do |msg|
      # end
      
      ws.onclose do
        if path = ws.request['Path']
          puts "WebSocket client disconnected from channel #{ws.request['Path']}."
          Humm::CHANNELS.path(path).remove ws
        end
      end
    end
  end
  
end