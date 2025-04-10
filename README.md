# memo-application
## 手順
`git clone`を実行しローカルに複製する
```
% git clone https://github.com/shiopro/memo-application.git
```
`memo-application`ディレクトリに移動する
```
% cd memo-application
```
必要なGemをインストールする
```
% bundle install
```
PostgreSQLにログインする
データベースを作成
```
% CREATE DATABASE memo_app;
```
SQLファイルを作成
(memo_data.sqlの中身)
```
CREATE TABLE memos (
  id serial PRIMARY KEY,
  title varchar(255),
  content text
);
```
テーブルを作成する
```
% psql -d memo_app -f memo_data.sql
```
sinatraを起動させる
```
% ruby memo.rb -p 4567
```
ブラウザで`http://localhost:4567/memos`にアクセスして確認する
