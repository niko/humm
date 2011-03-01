module Humm::Config
  class << self
    attr_reader :config
    
    def parse_command_line_opts(args)
      options = {
        websocket_sever: {},
        push_server: {},
        static_files: {},
        policy_server: {}
      }
      OptionParser.new do |opts|
        opts.banner = "Usage: example.rb [options]"
        
        opts.on "--static_index_template FILEPATH", "the static file" do |file_path|
          options[:static_files][:index_full_path] = File.expand_path(file_path)
          options[:static_files][:index_path]      = File.dirname File.expand_path(file_path)
          options[:static_files][:index_extension] = File.extname(file_path).gsub(/\A\./,'').to_sym
          options[:static_files][:index_template]  = File.basename(file_path, File.extname(file_path)).to_sym
        end
        
        opts.on "-l", "--launch_browser", "Launch a browser with the webinterface" do |launch|
          options[:static_files][:launch_browser] = true
        end
        
      end.parse!(args)
      
      options
    end
    
    def load(yaml_file=nil)
      yaml = File.open(yaml_file || File.join(base_path, 'defaults.yaml'))
      config = YAML::load yaml
      @config = set_listen_host!(config)
    end
    
    def base_path
      File.join( File.expand_path(File.dirname(__FILE__)), '..' )
    end
    
    def set_listen_host!(conf)
      conf[:websocket_sever][:listen]  ||= conf[:websocket_sever][:host]
      conf[:push_server][:listen]      ||= conf[:push_server][:host]
      conf[:static_files][:listen]     ||= conf[:static_files][:host]
      conf[:policy_server][:listen]    ||= conf[:policy_server][:host]
      return conf
    end
    
    def websocket_conf;       { :host => config[:websocket_sever][:listen], :port => config[:websocket_sever][:port]  }; end
    def push_server_conf;     { :host => config[:push_server][:listen]    , :port => config[:push_server][:port]      }; end
    def static_files_conf;    { :host => config[:static_files][:listen]   , :port => config[:static_files][:port]     }; end
    def policy_server_conf;   { :host => config[:policy_server][:listen]  , :port => config[:policy_server][:port]    }; end
    def push_and_static_conf; { :host => push_and_static_common_host      , :port => push_server_conf[:port]          }; end
    
    def push_and_static_common_host
      static_files_conf[:host] == push_server_conf[:host] ? push_server_conf[:host] : '0.0.0.0'
    end
    def push_and_static_same_port?
      config[:static_files][:port] == config[:push_server][:port]
    end
    
    def websocket_url
      "ws://#{config[:websocket_sever][:host]}:#{config[:websocket_sever][:port]}"
    end
    def push_server_url
      "http://#{config[:push_server][:host]}:#{config[:push_server][:port]}"
    end
    def static_files_url
      "http://#{config[:static_files][:host]}:#{config[:static_files][:port]}"
    end
    def policy_server_url
      "http://#{config[:policy_server][:host]}:#{config[:policy_server][:port]}"
    end
  end
end

