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

def post_memo(title, content)
  conn.exec_params('INSERT INTO memos(title, content) VALUES ($1, $2);', [title, content])
end

def edit_memo(title, content, id)
  conn.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3;', [title, content, id])
end

def delete_memo(id)
  conn.exec_params('DELETE FROM memos WHERE id = $1;', [id])
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
  memos = read_memo(params[:id])
  @title = memos['title']
  @content = memos['content']
  erb :edit
end

post '/memos' do
  title = params[:title]
  content = params[:content]
  post_memo(title, content)

  redirect '/memos'
end

patch '/memos/:id' do
  title = params[:title]
  content = params[:content]
  edit_memo(title, content, params[:id])

  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  delete_memo(params[:id])

  redirect '/memos'
end
