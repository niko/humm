module Humm
  CHANNELS = HeavyHash.new
  
  class << self
    def config
      return @config if @config
      
      @config = YAML::load( File.open( File.join( File.expand_path(File.dirname(__FILE__)), '../defaults.yaml' ) ) )
      @config[:websocket_sever][:listen]  ||= @config[:websocket_sever][:host]
      @config[:push_server][:listen]      ||= @config[:push_server][:host]
      @config[:static_files][:listen]     ||= @config[:static_files][:host]
      @config[:policy_server][:listen]    ||= @config[:policy_server][:host]
      
      @config
    end
    
    def websocket_conf;     { :host => config[:websocket_sever][:listen], :port => config[:websocket_sever][:port]  }; end
    def push_server_conf;   { :host => config[:push_server][:listen]    , :port => config[:push_server][:port]      }; end
    def static_files_conf;  { :host => config[:static_files][:listen]   , :port => config[:static_files][:port]     }; end
    def policy_server_conf; { :host => config[:policy_server][:listen]  , :port => config[:policy_server][:port]    }; end
    def push_and_static_conf; { :host => push_and_static_common_host    , :port => push_server_conf[:port]          }; end
    
    def push_and_static_common_host
      static_files_conf[:host] == push_server_conf[:host] ? push_server_conf[:host] : '0.0.0.0'
    end
    def push_and_static_same_port?
      config[:static_files][:port] == config[:push_server][:port]
    end
    
    def push_app  ; Class.new(Sinatra::Base){register Humm::PushInterface}; end
    def static_app; Class.new(Sinatra::Base){register Humm::StaticFiles}  ; end
    
    def push_and_static_app
      push_app.register Humm::StaticFiles
      push_app
    end
    
    def run_http_interfaces!
      if push_and_static_same_port?
        puts "== Push interface and static file server listening on #{push_and_static_conf[:host]}:#{push_and_static_conf[:port]}"
        push_and_static_app.run! push_and_static_conf
      else
        puts "== Push interface listening on #{push_server_conf[:host]}:#{push_server_conf[:port]}"
        push_app.run! push_server_conf
        
        puts "== Static file server started on #{static_files_conf[:host]}:#{static_files_conf[:port]}"
        static_app.run! static_files_conf
      end
    end
    
    def run!
      run_http_interfaces!
      
      puts "== WebSocket server listening on #{Humm.websocket_conf[:host]}:#{Humm.websocket_conf[:port]}"
      Humm::WebsocketServer.run! Humm.websocket_conf
      
      puts "== Policy server listening on #{Humm.policy_server_conf[:host]}:#{Humm.policy_server_conf[:port]}"
      Humm::FlashPolicyServer.run! Humm.policy_server_conf
    end
    
  end
end
