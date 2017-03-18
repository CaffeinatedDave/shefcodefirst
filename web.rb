require 'sinatra'
require 'erb'
require 'dotenv'
require 'open-uri'

#set :erb, :escape_html => true

Dotenv.load

use Rack::Logger
set :show_exceptions, :after_handler

helpers do
  def logger
    request.logger
  end
end

not_found do
  status 404
  erb '404'.to_sym
end

before do
  if ENV['debug'] == true
    logger.info request.env.to_s
  end
end

get '/?' do
  erb :home  
end

get '/about/?' do
  erb :about
end

get '/contact/?' do
  erb :contact
end

get '/:course/?' do
  logger.info "Trying to play #{params['course']}"
  begin
    erb params['course'].to_sym
  rescue
    status 404
    erb '404'.to_sym
  end
end
