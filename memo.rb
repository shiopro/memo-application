# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'cgi'
require 'pg'

FILE_PATH = 'data/memos.json'

def conn
  @conn ||= PG.connect(dbname: 'memo_app')
end

def read_memos
  conn.exec('SELECT * FROM memos')
end

def read_memo(id)
  result = conn.exec_params('SELECT * FROM memos WHERE id = $1;', [id])
  result[0]
end

get '/memos' do
  @memos = read_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  memos = read_memo(params[:id])
  @title = memos['title']
  @content = memos['content']
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
