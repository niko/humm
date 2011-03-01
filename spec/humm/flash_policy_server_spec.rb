describe Humm::FlashPolicyServer do
  describe "#receive_data" do
    before(:each) do
      @pol_server = Object.new.extend(Humm::FlashPolicyServer)
      @policy = <<EOF
<?xml version="1.0"?>
<!DOCTYPE cross-domain-policy SYSTEM "http://www.macromedia.com/xml/dtds/cross-domain-policy.dtd">
<cross-domain-policy>
  <allow-access-from domain="*" to-ports="*" />
</cross-domain-policy>
EOF
    end
    it "return the policy file" do
      @pol_server.should_receive(:send_data).with(@policy)
      @pol_server.receive_data('')
    end
    it "close the connection afterwards" do
      @pol_server.stub! :send_data => true
      @pol_server.should_receive(:close_connection_after_writing)
      @pol_server.receive_data('')
    end
  end
end