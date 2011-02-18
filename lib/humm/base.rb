module Humm
  CHANNELS = HeavyHash.new
  
  class << self
    
    def config
      Config.load
    end
    
    def push_app  ; Class.new(Sinatra::Base){register Humm::PushInterface}; end
    def static_app; Class.new(Sinatra::Base){register Humm::StaticFiles}  ; end
    
    def push_and_static_app
      push_app.register Humm::StaticFiles
      push_app
    end
    
    def run_http_interfaces!
      $0 = "Humm ::p::#{Humm::Config.push_server_url}::p:: ::s::#{Humm::Config.static_files_url}::s::"
      
      if Config.push_and_static_same_port?
        puts "== Push interface and static file server listening on #{push_and_static_conf[:host]}:#{push_and_static_conf[:port]}"
        push_and_static_app.run! push_and_static_conf
      else
        puts "== Push interface listening on #{Config.push_server_conf[:host]}:#{Config.push_server_conf[:port]}"
        push_app.run! Config.push_server_conf
        
        puts "== Static file server started on #{Config.static_files_conf[:host]}:#{Config.static_files_conf[:port]}"
        static_app.run! Config.static_files_conf
      end
    end
    
    def run!
      run_http_interfaces!
      
      puts "== WebSocket server listening on #{Humm::Config.websocket_conf[:host]}:#{Humm::Config.websocket_conf[:port]}"
      Humm::WebsocketServer.run! Humm::Config.websocket_conf
      
      puts "== Policy server listening on #{Humm::Config.policy_server_conf[:host]}:#{Humm::Config.policy_server_conf[:port]}"
      Humm::FlashPolicyServer.run! Humm::Config.policy_server_conf
    end
    
    def banner
<<-EOB

      ###########################################################
      #               Welcome to Humm                           #
      #                                                         #
      # Why don't you go to the Webinterface and have a ride?   #
      # #{Humm::Config.static_files_url}
      ###########################################################

EOB
    end
    
  end
end
