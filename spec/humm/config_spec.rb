require File.join( File.expand_path(File.dirname(__FILE__)), '../spec_helper' )

describe Humm::Config do
  describe ".parse_command_line_opts" do
    describe "--static_index_template" do
      before(:each) do
        @config = Humm::Config.parse_command_line_opts '--static_index_template /foo/bar.mustache'.split
      end
      it "adds the corresponding config variables" do
        @config[:static_files][:index_full_path].should == '/foo/bar.mustache'
        @config[:static_files][:index_path].should == '/foo'
        @config[:static_files][:index_extension].should == :mustache
        @config[:static_files][:index_template].should == :bar
      end
    end
    describe "--launch_browser" do
      before(:each) do
        @config = Humm::Config.parse_command_line_opts ['--launch_browser']
      end
      it "set the flag" do
        @config[:static_files][:launch_browser].should be_true
      end
    end
  end
  describe ".load" do
    describe "the file loading" do
      before(:each) do
        Humm::Config.stub! :base_path => '/hummdir'
        Humm::Config.stub! :set_listen_host!
      end
      describe "without argument" do
        it "load the defaults.yaml" do
          File.should_receive(:open).with('/hummdir/defaults.yaml').and_return(:the_config)
          YAML.should_receive(:load).with(:the_config)
          Humm::Config.load
        end
      end
      describe "with another file" do
        it "load the other file" do
          File.should_receive(:open).with('/whatever/foobar.yaml').and_return(:the_config)
          YAML.should_receive(:load).with(:the_config)
          Humm::Config.load '/whatever/foobar.yaml'
        end
      end
    end
    describe "the listen host settings" do
      before(:each) do
        File.stub! :open
        YAML.stub! :load
      end
      it "set the listen host" do
        Humm::Config.should_receive(:set_listen_host!)
        Humm::Config.load
      end
    end
  end
  describe ".set_listen_host!" do
    describe "if no :listen key is given" do
      before(:each) do
        @config = {
          :websocket_sever => {:host => :foo},
          :push_server     => {:host => :bar},
          :static_files    => {:host => :baz},
          :policy_server   => {:host => :fubble},
        }
      end
      it "sets the :listen key to :host" do
        Humm::Config.set_listen_host! @config
        @config[:websocket_sever][:listen].should == @config[:websocket_sever][:host]
        @config[:push_server][:listen].should     == @config[:push_server][:host]
        @config[:static_files][:listen].should    == @config[:static_files][:host]
        @config[:policy_server][:listen].should   == @config[:policy_server][:host]
      end
    end
    describe "if a :listen key is given" do
      before(:each) do
        @config = {
          :websocket_sever => {:host => :foo, :listen => :l},
          :push_server     => {:host => :bar, :listen => :m},
          :static_files    => {:host => :baz, :listen => :n},
          :policy_server   => {:host => :fubble, :listen => :o},
        }
      end
      it "just keeps it" do
        lambda{ Humm::Config.set_listen_host! @config }.should_not change(@config, :values)
      end
    end
  end
  
  describe "the configuration accessors" do
    before(:each) do
      Humm::Config.load
    end
    describe ".websocket_conf" do
      it "contain the websocket conf" do
        Humm::Config.websocket_conf.should == {:host=>"0.0.0.0", :port=>3333}
      end
    end
    describe ".push_server_conf" do
      it "contain the push server conf" do
        Humm::Config.push_server_conf.should == {:host=>"0.0.0.0", :port=>3080}
      end
    end
    describe ".static_files_conf" do
      it "contain the static files conf" do
        Humm::Config.static_files_conf.should == {:host=>"0.0.0.0", :port=>3000}
      end
    end
    describe ".policy_server_conf" do
      it "contain the policy server conf" do
        Humm::Config.policy_server_conf.should == {:host=>"0.0.0.0", :port=>3843}
      end
    end
    describe ".push_and_static_conf" do
      it "contain the push server conf" do
        Humm::Config.push_and_static_conf.should == {:host=>"0.0.0.0", :port=>3080}
      end
    end
    describe ".push_and_static_common_host" do
      it "contain the common listen host of the push server and the static server" do
        Humm::Config.push_and_static_common_host.should == "0.0.0.0"
      end
    end
  end
  describe ".push_and_static_same_port?" do
    it "returns whether the push server and the static server should run on the same port" do
      Humm::Config.push_and_static_same_port?.should be_false
    end
  end
  describe "full url accessors" do
    describe ".static_files_url" do
      it "returns the full url of the static file server" do
        Humm::Config.static_files_url.should == 'http://localhost:3000'
      end
    end
    describe ".push_server_url" do
      it "returns the full url of the push server" do
        Humm::Config.push_server_url.should == 'http://localhost:3080'
      end
    end
  end
  
end

