require "sinatra"
require "sinatra/reloader"
require 'tilt/erubi'

def chapter_titles
  File.readlines("data/toc.txt")
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @contents = File.readlines("data/toc.txt")
  erb :home
end

get "/chapters/:number" do
  @number = params[:number].to_i 
  @contents = File.readlines("data/toc.txt")
  @title = "Chapter #{@number}: #{@contents[@number - 1]}"

  @chapter = File.read("data/chp1.txt").split("\n\n")  

  erb :chapter
end