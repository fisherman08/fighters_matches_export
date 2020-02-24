# 試合日程エクスポート

日ハムのHPから試合日程をスクレイピングしてGoogleカレンダーに書き込む

## 使い方
1. bundle install
2. bundle exec ruby ./src/main/exec.rb

## 注意
* 2019年1月時点の公式サイトに対応
* 登録用のカレンダーは必ず専用のものを用意する
    * 同じ日付の試合があったら削除してしまう
    * したがってダブルヘッダーには非対応

## Credentialとtokenの用意方法
0. (あったら)config/token.yamlを削除
1. https://console.developers.google.comにアクセス
2. FightersCalendar -> 認証情報を作成 -> jsonをダウンロードでconfig/credentials.jsonという名前で保存
3. exec.rbを実行
4. 途中でurlにアクセスされるように指示されるのでその通りにする。
5. アクセス先で表示されたトークンをコマンドラインに貼り付けてenter
