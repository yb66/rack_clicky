# encoding: UTF-8

require 'rubygems'
require 'bundler'
Bundler.setup(:examples)

root = File.expand_path File.dirname(__FILE__)
require File.join( root , "./app.rb" )

# everything else separate module/file (config.rb) to make it easier to set up tests

map "/" do
  run Example.app
end