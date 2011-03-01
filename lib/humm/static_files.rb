module Humm::StaticFiles
    
  def self.registered(app)
    app.use Rack::CommonLogger
    app.use Rack::Cache, :verbose => false
    
    app.set :public, File.join( File.expand_path(File.dirname(__FILE__)), '../assets' )
    
    app.set :index_full_path, Humm.config[:static_files][:index_full_path]
    app.set :index_path,      Humm.config[:static_files][:index_path]
    app.set :index_extension, Humm.config[:static_files][:index_extension]
    app.set :index_template,  Humm.config[:static_files][:index_template]
    
    app.register Mustache::Sinatra
    app.set :views, app.index_path
    app.set :mustache, { :templates => app.index_path, :layout => false }
    
    # Sanitize URL ending with a '/':
    # 
    app.get '*/' do
      pass if params[:splat].first == ''
      redirect params[:splat].first
    end
    
    # Allways deliver THE HTML FILE (TM).
    # Note that files lib/assets are served first.
    # 
    app.get '*' do
      expires 3600, :public, :must_revalidate
      
      locals = {
        :websocket_server => Humm::Config.websocket_url,
        :push_server      => Humm::Config.push_server_url,
        :config           => Humm::config
      }
      
      case app.index_extension
      when :html      then send_file app.index_full_path
      when :mustache  then mustache app.index_template, :locals => locals
      when :haml      then haml app.index_template,     :locals => locals
      end
      
    end
  end
end
