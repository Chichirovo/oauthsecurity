require 'rubygems'
require 'sinatra'


set :views, settings.root
set :public_folder, 'dist'

#set :show_exceptions, false

disable :sessions
#disable :protection

#index = File.open('dist/Sakurity.html')

get '/' do
  response.headers['Access-Control-Allow-Origin'] = '*'
  response.headers['Access-Control-Allow-Credentials'] = 'true'
  File.open('dist/Sakurity.html')
end
