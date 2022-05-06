require 'net/http'
require 'uri'
require 'json'
require_relative "proxy"

module FieldReports

  class HttpProxy < Proxy

    def initialize(base_address)
      url = URI.parse(base_address)
      @http = Net::HTTP.new(url.host, url.port)
    end

    def version
      begin
        req = Net::HTTP::Get.new('/version')
        res = @http.request(req)
        case res
        when Net::HTTPOK
          return res.body
        when Net::HTTPClientError, Net::HTTPInternalServerError
          res.value
        end
      rescue Net::ProtocolError => exn
        raise ReportsError, response_message(res)
      rescue => exn
        raise ReportsError, exn_message(exn)
      end
    end

    def render(param)
      begin
        req = Net::HTTP::Post.new('/render')
        req["Content-Type"] = "application/json"
        req.body = param.is_a?(Hash) ? param.to_json : param
        res = @http.request(req)
        case res
        when Net::HTTPOK
          return res.body
        when Net::HTTPClientError, Net::HTTPInternalServerError
          res.value
        end
      rescue Net::ProtocolError => exn
        raise ReportsError, response_message(res)
      rescue => exn
        raise ReportsError, exn_message(exn)
      end
    end

    def parse(pdf)
      begin
        req = Net::HTTP::Post.new('/parse')
        req["Content-Type"] = "application/pdf"
        req.body = pdf
        res = @http.request(req)
        case res
        when Net::HTTPOK
          return JSON.parse(res.body)
        when Net::HTTPClientError, Net::HTTPInternalServerError
          res.value
        end
      rescue Net::ProtocolError => exn
        raise ReportsError, response_message(res)
      rescue => exn
        raise ReportsError, exn_message(exn)
      end
    end

    # @private
    def response_message(res)
      return format("Status Code = %s, Reason = %s, Response = %s", res.code, res.message, res.body)
    end

    # @private
    def exn_message(exn)
      return format("Fail to HTTP comunication: %s.", message)
    end

  end
end