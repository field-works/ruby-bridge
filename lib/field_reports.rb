# frozen_string_literal: true

require 'uri'
require_relative 'field_reports/version'
require_relative 'field_reports/proxy'
require_relative 'field_reports/http_proxy'
require_relative 'field_reports/exec_proxy'

module FieldReports

  # Field Reportsと連携するためのProxyオブジェクトを生成します。
  #
  class Bridge

    # Field Reportsと連携するためのProxyオブジェクトを生成します。
    #
    # @example コマンド連携時
    #   require "field_reports"
    #   reports = FieldReports::Bridge.create_proxy("exec:/usr/local/bin/reports?cwd=/usr/share&amp;logleve=3")
    #
    # @example HTTP連携時
    #   require "field_reports"
    #   reports = FieldReports::Bridge.create_proxy("http://localhost:50080/")
    #
    # @param [String] uri Field Reportsとの接続方法を示すURI．  
    #   nilの場合，環境変数'REPORTS_PROXY'よりURIを取得します。  
    #   環境変数'REPORTS_PROXY'も未設定の場合のURIは，"exec:reports"とします。
    #
    #   書式（コマンド連携時）:
    #
    #     exec:{exePath}?cwd={cwd}&loglevel={logLevel}
    #
    #   - cwd, loglevelは省略可能です。
    #   - loglevelが0より大きい場合，標準エラー出力にログを出力します。
    #
    #   書式（HTTP連携時）:
    #
    #     http://{hostName}:{portNumber}/
    #
    # @return [Proxy] Field Reports Proxyオブジェクト
    #
    def self.create_proxy(uri = nil)
      uri = uri.nil? ? ENV['REPORTS_PROXY'] : uri
      uri = uri.nil? ? "exec:reports" : uri
      if uri.start_with?("exec:") then
        uris = uri.split(':')[1].split("?")
        if uris.length == 2 then
          q = URI.decode_www_form(uris[1]).to_h
          cwd = q.has_key?('cwd') ? q['cwd'] : "."
          loglevel = q.has_key?('loglevel') ? q['loglevel'].to_i : 0
          return Bridge.create_exec_proxy(uris[0], cwd, loglevel, STDERR)
        else
          return Bridge.create_exec_proxy(uris[0], ".", 0, STDERR)
        end
      else
        return Bridge.create_http_proxy(uri)
      end
    end

    # Field Reportsとコマンド呼び出しにより連携するためのProxyオブジェクトを生成します。
    #
    # @param [String] exe_path Field Reportsコマンドのパス
    # @param [String] cwd Field Reportsプロセス実行時のカレントディレクトリ
    # @param [Integer] loglevel ログ出力レベル
    # @param [IO] logout ログ出力先Stream
    # @return [ExecProxy] Field Reports Proxyオブジェクト
    def self.create_exec_proxy(
      exe_path = "reports",
      cwd = ".",
      loglevel = 0, logout = STDERR)
      return ExecProxy.new(exe_path, cwd, loglevel, logout)
    end

    # Field ReportsとHTTPで連携するためのProxyオブジェクトを生成します。
    #
    # @param [String] base_address ベースURI
    # @return [HttpProxy] Field Reports Proxyオブジェクト
    # @note
    #   reportsコマンドがサーバーモードで起動していることが前提となります。
    #   $ reports server -l3
    def self.create_http_proxy(
      base_address = "http://localhost:50080/")
      return HttpProxy.new(base_address)
    end
  end

end
