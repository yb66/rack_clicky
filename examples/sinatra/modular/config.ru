# encoding: UTF-8

require 'rubygems'
require 'bundler'
Bundler.setup(:examples)

root = File.expand_path File.dirname(__FILE__)
require File.join( root , "./app.rb" )
require File.join( root , "./app2.rb" )

# everything else separate module/file (config.rb) to make it easier to set up tests

map "/" do
  run Example.app
end

map "/app2" do
  run Example::App2
end