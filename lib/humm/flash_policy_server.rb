module Humm::FlashPolicyServer
  
  def receive_data data
    policy = <<EOF
<?xml version="1.0"?>
<!DOCTYPE cross-domain-policy SYSTEM "http://www.macromedia.com/xml/dtds/cross-domain-policy.dtd">
<cross-domain-policy>
  <allow-access-from domain="*" to-ports="*" />
</cross-domain-policy>
EOF
    send_data policy and close_connection_after_writing
  end
  
  def self.run!(opts)
    EventMachine::start_server opts[:host], opts[:port], self
  end
  
end
