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
`data/memos.json`を作成する
```
% mkdir -p data
% echo "{}" > data/memos.json
```
sinatraを起動させる
```
% ruby memo.rb -p 4567
```
ブラウザで`http://localhost:4567/memos`にアクセスして確認する
