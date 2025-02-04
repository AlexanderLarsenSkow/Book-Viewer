require "sinatra"
require "sinatra/reloader"
require 'tilt/erubi'

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

