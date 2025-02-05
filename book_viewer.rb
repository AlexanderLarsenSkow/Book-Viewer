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

def chapters_hash
  chapters = Dir.new("./data").children[0..11]
  hash = {}
  return hash if @search == ''

  @contents.each_with_index do |title, index|
    hash[title] = File.read("./data/#{chapters[index]}")
  end
  hash
end

def select_titles(chapters_hash, search)
  chapters_hash.select {|_, chapter| chapter.include? search }.keys
end

def find_indicies
  return unless @selected_titles
  indicies = []

  @selected_titles.each do |title|
    indicies << (@contents.index(title) + 1)
  end
  indicies
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
  chapters_hash = chapters_hash()
  @selected_titles = select_titles(chapters_hash, @search)
  @indicies = find_indicies

  erb :search
end
