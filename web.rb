require 'contentful'
require 'dotenv'
require 'erb'
require 'open-uri'
require 'sinatra'
require 'sinatra/cookies'

Dotenv.load

use Rack::Logger
set :show_exceptions, :after_handler

client = Contentful::Client.new(
  access_token: ENV['CONTENTFUL_ACCESS_TOKEN'],
  space: ENV['CONTENTFUL_SPACE_NAME']
)

use Rack::Session::Cookie, :key => 'rack.session',
                           :domain => ENV['DOMAIN'],
                           :path => '/',
                           :expire_after => 10 * 365 * 24 * 60 * 60, # 10 years.
                           :secret => ENV['COOKIE_SECRET']

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
  logger.info(cookies)
  @showCookieNotification = cookies[:acceptCookies] != 'Y'
  @menu = {}
  @menu[:html] = client.entries(content_type: 'course').select{|c| c.type == "HTML"}.sort{|l, r| l.fields[:order] <=> r.fields[:order]}
  @menu[:python] = client.entries(content_type: 'course').select{|c| c.type == "Python"}.sort{|l, r| l.fields[:order] <=> r.fields[:order]}
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

get '/course/:course/?' do
  logger.info "Trying to find #{params['course']}"
    @projects = client.entries(content_type: 'project').select{|c| c.course.course_name == params['course']}
    @winners = @projects.select{|p| p.winner > 0}.sort{|l, r| l.order <=> r.order}
    @course = client.entries(content_type: 'course').select{|c| c.course_name == params['course']}[0]
    @type = @course.type == "HTML" ? "HTML Beginners" : "Python Advanced"
    erb :course
end
