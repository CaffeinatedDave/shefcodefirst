require 'sinatra'
require 'erb'
require 'dotenv'
require 'open-uri'
require 'contentful'

#set :erb, :escape_html => true

Dotenv.load

use Rack::Logger
set :show_exceptions, :after_handler

client = Contentful::Client.new(
  access_token: ENV['CONTENTFUL_ACCESS_TOKEN'],
  space: ENV['CONTENTFUL_SPACE_NAME']
)

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
#  @menu = {}
#  @menu[:HTML] = client.entries(content_type: 'courses').select{|c| c.type == "HTML"}
#  @menu[:Python] = client.entries(content_type: 'courses').select{|c| c.type == "Python"}
  if ENV['debug'] == true
    logger.info request.env.to_s
  end
end

get '/?' do
  @instructors = client.entries(content_type: 'instructors').select{|c| c.role == "instructor"}.sort{|l, r| l.fields[:order] <=> r.fields[:order]}
  @ambassadors = client.entries(content_type: 'instructors').select{|c| c.role == "ambassador"}.sort{|l, r| l.fields[:order] <=> r.fields[:order]}
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
