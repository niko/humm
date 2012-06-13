$:.unshift File.expand_path('../lib', __FILE__)
require 'humm/version'

Gem::Specification.new do |s|
  s.name         = "humm"
  s.version      = Humm::VERSION
  s.authors      = ["Niko Dittmann"]
  s.email        = "mail+git@niko-dittmann.com"
  s.homepage     = "http://github.com/niko/humm"
  s.summary      = "Websocket push server ala Pusher."
  s.description  = "Websocket push server ala Pusher."
  
  s.files        = Dir.glob('lib/**/*') + Dir.glob('examples/**/*')
  s.bindir       = 'bin'
  s.executables  = ['humm', 'hummer']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  
  s.add_runtime_dependency 'eventmachine'
  s.add_runtime_dependency 'em-websocket'
  s.add_runtime_dependency 'sinatra'
  s.add_runtime_dependency 'mustache'
  s.add_runtime_dependency 'haml'
  s.add_runtime_dependency 'heavy_hash'
  s.add_runtime_dependency 'rack'
  s.add_runtime_dependency 'rack-cache'
  s.add_runtime_dependency 'rack-cors'
end
