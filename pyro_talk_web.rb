# myapp.rb
require 'rubygems'
require 'sinatra'
require 'lib/pyrotalk'

get '/' do
  haml :index
  @original_text = ''
  @text = ''
end

post '/' do
  pyro_talk = PyroTalk.new
  @original_text = params[:text]
  @text = pyro_talk.translate(@original_text)
  haml :index
end