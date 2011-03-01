describe Humm::PushInterface do
  include Rack::Test::Methods
  
  def app
    Class.new(Sinatra::Base){register Humm::PushInterface}
  end
  
  describe "POST requests" do
    describe "when the request has a message parameter" do
      it "accepts the request" do
        post '/accepts/the/request', :message => 'foobar'
        puts last_response.body
        last_response.should be_ok
      end
      it "gets the clients from the CHANNELS" do
        pending 'how would one test this?'
        post '/gets/the/clients/from/the/CHANNELS', :message => 'foobar'
      end
      it "sends the message to all clients" do
        pending 'how would one test this?'
        post '/sends/the/message/to/all/clients', :message => 'foobar'
      end
    end
    describe "when the request has no message parameter" do
      it "doesnt accept the request" do
        post '/'
        last_response.should_not be_ok
        last_response.body.should == 'Push needs to have a message parameter'
      end
    end
  end
  describe "OPTIONS requests" do
    it "are working" do
      header 'Access-Control-Request-Method', 'POST'
      header 'Origin', 'http://localhost:3000'
      request '/', :method => "OPTIONS"
      last_response.headers['Access-Control-Allow-Origin'].should_not be_nil
    end
  end
end

# OPTIONS / HTTP/1.1
# Host: localhost:3080
# User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; de; rv:1.9.2.13) Gecko/20101203 Firefox/3.6.13
# Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
# Accept-Language: de-de,de;q=0.8,en-us;q=0.5,en;q=0.3
# Accept-Encoding: gzip,deflate
# Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7
# Keep-Alive: 115
# Connection: keep-alive
# Origin: http://localhost:3000
# Access-Control-Request-Method: POST
