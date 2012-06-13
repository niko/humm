describe Humm::PushInterface do
  include Rack::Test::Methods
  
  let(:app){ Class.new(Sinatra::Base){register Humm::PushInterface} }
  
  describe "POST requests" do
    describe "when the request has a message parameter" do
      it "accepts the request" do
        post '/accepts/the/request', :message => 'foobar'
        puts last_response.body
        last_response.should be_ok
      end
      it "gets the clients from the CHANNELS" do
        Humm::Channels.should_receive(:clients_for).with('/gets/the/clients/from/the/CHANNELS')
        post '/gets/the/clients/from/the/CHANNELS', :message => 'foobar'
      end
      it "sends the message to all clients" do
        client = stub(:client, :request => {'path' => '/'})
        client.should_receive(:send).with('foobar')
        Humm::Channels.stub! :clients_for => [client]
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
