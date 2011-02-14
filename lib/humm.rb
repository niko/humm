# -*- encoding : utf-8 -*-

require 'rubygems'
require 'eventmachine'
require 'em-websocket'
require 'sinatra/base'
require 'heavy_hash'
require 'json'

module Humm
  CHANNELS = HeavyHash.new
end

require 'humm/flash_policy_server'
require 'humm/push_interface'
require 'humm/static_files'
require 'humm/websocket_server'

policy_server_port = 3843 # 843
policy_server_host = '0.0.0.0'

push_server_port = 3080
push_server_host = '0.0.0.0'

static_files_port = 3000
static_files_host = '0.0.0.0'

websocket_port = 3333
websocket_host = '0.0.0.0'

$0 = "humm:ws://#{websocket_host}:#{websocket_port} push:http://#{push_server_host}:#{push_server_port} static:http://#{static_files_host}:#{static_files_port}, policy:#{policy_server_host}:#{policy_server_port}"

EventMachine.run do

  puts "== Static file server started on #{static_files_host}:#{static_files_port}"
  Humm::StaticFiles.run! :host => static_files_host, :port => static_files_port
  
  puts "== WebSocket server listening on #{websocket_host}:#{websocket_port}"
  Humm::WebsocketServer.run! :host => websocket_host, :port => websocket_port
  
  puts "== Policy server listening on #{policy_server_host}:#{policy_server_port}"
  Humm::FlashPolicyServer.run! :host => policy_server_host, :port => policy_server_port
  
  puts "== Push interface listening on #{push_server_host}:#{push_server_port}"
  Humm::PushInterface.run! :host => push_server_host, :port => push_server_port

end
