Ruby Bridge 2.0
=============================

Field Reports Ruby Bridge（以降，本モジュールと表記します）は，
PDF帳票ツールField ReportsをRubyから利用するためのライブラリです。

Ruby Bridge APIを通じて，Field Reportsの各機能を呼び出すことができます。

* Field Reportsのバージョンを取得する。

* レンダリング・パラメータを元にPDFを生成し，結果をバイナリ文字列として受け取る。

* PDFデータを解析し，フィールドや注釈の情報を取得する。

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

## 必要条件
### Field Reports本体

本モジュールのご利用に際しては，Field Reports本体がインストール済みである必要があります。

    https://www.field-works.co.jp/製品情報/

Field Reports本体のインストール手順につきましては，
ユーザーズ・マニュアルを参照してください。

### 連携手段の選択

本モジュールとField Reports本体との連携方法として，以下の２種類があります。
システム構成に応じて，適切な連携方法を選択してください。

* コマンド呼び出しによる連携
    - 本モジュールとreports本体を同一マシンに配置する必要があります。
    - パスが通る場所にreportsコマンドを置くか，reportsコマンドのパスをAPIに渡してください。

* HTTP通信による連携
    - リモートマシンにField Reportsを配置することができます。
    - Field Reportsは，サーバーモードで常駐起動させてください（`reports server`）。
    - サーバーモードで使用するポート番号（既定値：`50080`）の通信を許可してください。

### Ruby

Ruby 2.6以上

## インストール
### インストール媒体からのインストール

gemコマンドを利用して，インストール媒体のgemファイルをインストールしてください。

```shell
$ gem install field_reports-2.0.0rc3.gem
```

### GitHubからのインストール

GitHubに登録されているソースコードからインストールする場合は，以下のコマンドを実行してください。

```shell
$ gem install specific_install
$ gem specific_install -l https://github.com/field-works/ruby-bridge.git -b 2.0.0
```

## 動作確認
### コマンド連携時

本モジュールのソースコードを展開して，以下のコマンドを実行してください。

```shell
$ bundle exec rspec
```

reportsコマンドにパスが通っていない場合は，環境変数'REPORTS_PROXY'でコマンドのパスを指定してください
（動作環境に応じて，パスは変更してください）。

LinuxまたはmacOSでの実行例：
```shell
$ REPORTS_PROXY=exec:/usr/local/bin/reports bundle exec rspec
```

Windowsでの実行例：
```cmd
> set REPORTS_PROXY="C:\Program Files\Field Works\Field Reports 2.0\reports.exe"
> bundle exec rspec
```

### HTTP通携時

Field Reportsをサーバーモードで起動してください。

```shell
$ reports server -l4
```

本モジュールのソースコードを展開して，以下のコマンドを実行してください
（動作環境に応じて，URLは変更してください）。

LinuxまたはmacOSでの実行例：
```shell
$ REPORTS_PROXY=http://localhost:50080/ bundle exec rspec
```

Windowsでの実行例：
```shell
> set REPORTS_PROXY=http://localhost:50080/
> bundle exec rspec
```

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

## 著者

* 合同会社フィールドワークス / Field Works, LLC
* https://www.field-works.co.jp/
* support@field-works.co.jp