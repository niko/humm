require 'rubygems'
require 'eventmachine'
require 'em-websocket'
require 'sinatra/base'
require 'mustache/sinatra'
require 'haml'
require 'heavy_hash'
require 'json'
require 'yaml'
require 'rack/cache'
require 'optparse'

require 'humm/base'
require 'humm/config'
require 'humm/static_files'
require 'humm/push_interface'
require 'humm/flash_policy_server'
require 'humm/websocket_server'

EM.run do
  Humm.run!
end
