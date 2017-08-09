require "rubygems"
require "sinatra/base"

require File.expand_path '../web.rb', __FILE__

use Rack::Logger

run Sinatra::Application

