require 'net/http'
require 'uri'
require 'json'

module FieldReports

  # Field Reportsと連携するためのProxyオブジェクト
  #
  class Proxy

    # バージョン番号を取得します。
    #
    # @return [String] バージョン番号
    # @raise [ReportsError] Field Reportsとの連携に失敗した場合に発生
    def version
      raise "not implemented"
    end

    # レンダリング・パラメータを元にレンダリングを実行します。
    #
    # @param [String|Hash] param JSON文字列またはハッシュ値レンダリング・パラメータ
    # @return [String] PDFデータ
    # @raise [ReportsError] Field Reportsとの連携に失敗した場合に発生
    # @note ユーザーズ・マニュアル「第5章 レンダリングパラメータ」参照

    def render(param)
      raise "not implemented"
    end

    # PDFデータを解析し，フィールドや注釈の情報を取得します。
    #
    # @param [String] pdf PDFデータ
    # @return [String] 解析結果
    # @raise [ReportsError] Field Reportsとの連携に失敗した場合に発生
    def parse(pdf)
      raise "not implemented"
    end
  end

  class ReportsError < StandardError
    def initialize(msg)
      super(msg)
    end
  end

end