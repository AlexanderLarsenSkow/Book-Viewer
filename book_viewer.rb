require "sinatra"
require "sinatra/reloader"
require 'tilt/erubi'

before do
  @contents = File.readlines("data/toc.txt")
  @chapters = Dir.new("./data").children[0..11]
end

helpers do
  def in_paragraphs(chapter)
    id = 0

    (chapter.split("\n\n").map do |para|
      id += 1
      "<p id = #{id}>#{para}</p>"
    end).join
  end
end

def sort_chapters
  @chapters.sort_by do |file_name|
    file_name.gsub(/[a-zA-Z.]/, "").to_i
  end
end

def paragraphs_array
  result = []

  sort_chapters.each_with_object({}) do |chapter, hash|
    hash = {}
    id = 1
    File.read("data/#{chapter}").split("\n\n").each do |paragraph|
      hash[id] = paragraph
      id += 1
    end
    result << hash
  end
  result
end

def search_paragraphs
  return [] if (!@search || @search == "")
  paragraphs_array.map do |para_hash|
    para_hash.select { |_, paragraph| paragraph.include? @search}
  end
end

not_found do
  redirect "/"
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/chapters/:number" do
  @number = params[:number].to_i
  
  redirect "/" unless (1..@contents.size).cover? @number

  @title = "Chapter #{@number}: #{@contents[@number - 1]}"
  @chapter = File.read("data/chp#{@number}.txt")  

  erb :chapter
end

get "/search" do
  @search = params[:query]
   
    @matches = search_paragraphs
    p @matches
    p @search

  erb :search
end
