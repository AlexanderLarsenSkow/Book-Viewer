require "sinatra"
require "sinatra/reloader"
require 'tilt/erubi'

before do
  @contents = File.readlines("data/toc.txt")
end

helpers do
  def in_paragraphs(chapter)
    chapter.split("\n\n").map { |para| "<p>#{para}</p>"}.join
  end
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/chapters/:number" do
  @number = params[:number].to_i 
  @title = "Chapter #{@number}: #{@contents[@number - 1]}"
  @chapter = File.read("data/chp#{@number}.txt")  

  erb :chapter
end