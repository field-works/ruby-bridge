Ruby Bridge 2.0.0
=================

Field Reports Ruby Bridge（以降，本モジュールと表記します）は，
PDF帳票ツールField ReportsをRubyから利用するためのライブラリです。

Ruby Bridge APIを通じて，Field Reportsの各機能を呼び出すことができます。

* Field Reportsのバージョンを取得する。

* レンダリング・パラメータを元にPDFを生成し，結果をバイナリ文字列として受け取る。

* PDFデータを解析し，フィールドや注釈の情報を取得する。

## 必要条件
### Field Reports本体

本モジュールのご利用に際しては，Field Reports本体が導入済みである必要があります。

Field Reportsのご購入もしくは試用版のダウンロードにつきましては，
下記サイトをご参照ください。

https://www.field-works.co.jp/製品情報/

### 連携手段の選択

本モジュールとField Reports本体との連携方法として，以下の２種類があります。
システム構成に応じて，適切な連携方法を選択してください。

* コマンド呼び出しによる連携
    - reports本体と本モジュールを同一マシンに配置する必要があります。
    - パスが通る場所にreportsコマンドを置くか，reportsコマンドのパスをAPIに渡してください。

* HTTP通信による連携
    - Field Reports本体をリモートマシンに配置することができます。
    - Field Reportsは，サーバーモードで常駐起動させてください（`reports server`）。
    - サーバーモードで使用するポート番号（既定値：`50080`）の通信を許可してください。

### Ruby処理系

* Ruby 2.5以上

## インストール
### インストール媒体からのインストール

gemコマンドを利用して，インストール媒体のgemファイルをインストールしてください。

```
$ gem install field_reports-2.0.0.gem
```

### GitHubからのインストール

GitHubに登録されているソースコードからインストールする場合は，以下のコマンドを実行してください。

```
$ gem install specific_install
$ gem specific_install -l https://github.com/field-works/ruby-bridge.git -b 2.0.0
```

## 動作確認
### コマンド連携時

以下のコマンドを実行してください。

```
$ irb
> require 'field_reports'
> reports = FieldReports::Bridge.create_proxy("exec:/usr/local/bin/reports")
> reports.version()
=> "2.0.0"
> reports.render({})
=> "%PDF-1.6\n%\x80\x81\x82\x83\n..."
```

- 動作環境に応じて，create_proxy()に与えるパスを適宜変更してください。  
  （Windowsでは，"exec:C:/Program Files/Field Works/Field Reports x.x/bin/reports.exe"など）

### HTTP通携時

Field Reportsをサーバーモードで起動してください。

```
$ reports server -l3
```

次に，以下のコマンドを実行してください

```shell
$ irb
> require 'field_reports'
> reports = FieldReports::Bridge.create_proxy("http://localhost:50080/")
> reports.version()
=> "2.0.0"
> reports.render({})
=> "%PDF-1.6\n%\x80\x81\x82\x83\n..."
```

- 動作環境に応じて，create_proxy()に与えるURLを適宜変更してください。  

## API使用例

```ruby
require "field_reports"

reports = FieldReports::Bridge.create_proxy()
param = {
  "template": {"paper": "A4"},
  "context": {
    "hello": {
      "new": "Tx",
      "value": "Hello, World!",
      "rect": [100, 700, 400, 750]
    }
  }
}
pdf = reports.render(param)
```

## ドキュメント

Field Reportsの詳細な利用方法につきましては，
[Field Reportsサポートページ](https://support.field-works.co.jp/)を参照してください。

* ユーザーズマニュアル
* FAQ
* チュートリアル
* サンプルプログラム

## ライセンス

本モジュールのソースコードは，BSDライセンスのオープンソースとします。

https://github.com/field-works/ruby-bridge/

以下のような場合，自由に改変／再配布していただいて結構です。

* 独自機能の追加

* ビルド/実行環境等の違いにより，本モジュールが正常に機能しない。

* 未サポートの.NETバージョンへの対応のため改造が必要。

* 他の言語の拡張ライブラリ作成のベースとして利用したい。

ただし，ソースを改変したモジュール自体において問題が発生し場合については，
サポート対応いたしかねますのでご了承ください
（Field Reports本体もしくはオリジナルの本モジュールに起因する問題であれば対応いたします）。

## 著者

* 合同会社フィールドワークス / Field Works, LLC
* https://www.field-works.co.jp/
* support@field-works.co.jp