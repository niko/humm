module Humm::StaticFiles
    
  def self.registered(app)
    app.use Rack::CommonLogger
    app.use Rack::Cache, :verbose => false
    
    app.register Mustache::Sinatra
    app.set :mustache, {
      :views     => File.join( File.expand_path(File.dirname(__FILE__)), '../views' ),
      :templates => File.join( File.expand_path(File.dirname(__FILE__)), '../templates' ),
      :namespace => Humm
    }
    
    app.set :static, true
    app.set :public, File.join( File.expand_path(File.dirname(__FILE__)), '../assets' )
    
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
      mustache :index, :layout => false
    end
  end
end
