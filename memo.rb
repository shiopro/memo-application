# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

FILE_PATH = 'data/memos.json'

def get_memos(file_path)
  File.open(file_path) { |f| JSON.parse(f.read) }
end

get '/memos' do
  @memos = get_memos(FILE_PATH)
  erb :index
end
