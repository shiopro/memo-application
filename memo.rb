# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'cgi'

FILE_PATH = 'data/memos.json'

def get_memos(file_path)
  File.open(file_path) { |f| JSON.parse(f.read) }
end

def save_memos(file_path, memos)
  File.open(file_path, 'w') { |f| JSON.dump(memos, f) }
end

get '/memos' do
  @memos = get_memos(FILE_PATH)
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  memos = get_memos(FILE_PATH)
  @title = memos[params[:id]]['title']
  @content = memos[params[:id]]['content']
  erb :show
end

get '/memos/:id/edit' do
  memos = get_memos(FILE_PATH)
  @title = memos[params[:id]]['title']
  @content = memos[params[:id]]['content']
  erb :edit
end

post '/memos' do
  title = params[:title]
  content = params[:content]

  memos = get_memos(FILE_PATH)
  id = ((memos.keys.map(&:to_i).max || 0) + 1).to_s
  memos[id] = { 'title' => title, 'content' => content }
  save_memos(FILE_PATH, memos)

  redirect '/memos'
end

patch '/memos/:id' do
  title = params[:title]
  content = params[:content]

  memos = get_memos(FILE_PATH)
  memos[params[:id]] = { 'title' => title, 'content' => content }
  save_memos(FILE_PATH, memos)

  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memos = get_memos(FILE_PATH)
  memos.delete(params[:id])
  save_memos(FILE_PATH, memos)

  redirect '/memos'
end
