require "sinatra"
require "sinatra/reloader"
require 'tilt/erubi'

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @contents = File.readlines("data/toc.txt")
  erb :home
end

