class Humm::StaticFiles < Sinatra::Base
  use Rack::CommonLogger
  
  set :static, true
  set :public, File.join( File.expand_path(File.dirname(__FILE__)), '../assets' )
  
  # Sanitize URL ending with a '/':
  # 
  get '*/' do
    pass if params[:splat].first == ''
    redirect params[:splat].first
  end
  
  # Allways deliver THE HTML FILE (TM).
  # Note that files lib/assets are served first.
  # 
  get '*' do
    send_file File.join( File.expand_path(File.dirname(__FILE__)), '../assets/index.html' )
  end
  
end
