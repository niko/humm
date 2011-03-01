class Humm::Channels
  class << self
    
    def channels
      @channels ||= HeavyHash.new
    end
    
    def clients_for(path)
      channels.path(path).parents_content(true)                                                                                                  
    end
    
    def add_client(client)
      path = client.request['Path']
      puts "WebSocket client connected on channel #{path}."
      channels.path(path) << client                                                                                                               
    end
    
    def remove_client(client)
      if path = client.request['Path']
        puts "WebSocket client disconnected from channel #{path}."
        channels.path(path).remove client                                                                                                                      
      end
    end
    
  end
end
