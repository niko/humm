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
    
    def load
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
    def static_files_url
      "http://#{Humm::config[:static_files][:host]}:#{Humm::config[:static_files][:port]}"
    end
  end
end

Humm.config
options = Humm::Config.parse_command_line_opts ARGV

Humm.config[:websocket_sever].update  options[:websocket_sever]
Humm.config[:push_server].update      options[:push_server]
Humm.config[:static_files].update     options[:static_files]
Humm.config[:policy_server].update    options[:policy_server]

puts Humm.config.inspect

puts Humm.banner

if Humm::config[:static_files][:launch_browser]
  require 'launchy'
  Thread.new {
    sleep 1 # so the server is running
    Launchy.open Humm::Config.static_files_url
  }
end
