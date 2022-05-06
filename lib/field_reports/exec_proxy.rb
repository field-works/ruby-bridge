require 'open3'
require 'json'
require_relative "proxy"

module FieldReports

  class ExecProxy < Proxy

    def initialize(exe_path, cwd, loglevel, logout)
      @exe_path = exe_path
      @cwd = cwd
      @loglevel = loglevel
      @logout = logout
    end

    def version
      begin
        Open3.popen3(@exe_path, "version") {|i, o, e, t|
          @logout.write(e.read)
          if t.value.exitstatus != 0 then
            raise RuntimeError, format("Exit Code = %d", t.value.exitstatus)
          end
          return o.read.strip
        }
      rescue => exn
        raise ReportsError, exn_message(exn)
      end
    end

    def render(param)
      begin
        body = param.is_a?(Hash) ? param.to_json : param
        Open3.popen3(@exe_path, "render", "-l", @loglevel.to_s, "-", "-", :chdir=>@cwd) {|i, o, e, t|
          i.write(body)
          i.close
          @logout.write(e.read)
          if t.value.exitstatus != 0 then
            raise RuntimeError, format("Exit Code = %d", t.value.exitstatus)
          end
          return o.read
        }
      rescue => exn
        raise ReportsError, exn_message(exn)
      end
    end

    def parse(pdf)
      begin
        Open3.popen3(@exe_path, "parse", "-", :chdir=>@cwd) {|i, o, e, t|
          i.write(pdf)
          i.close
          @logout.write(e.read)
          if t.value.exitstatus != 0 then
            raise RuntimeError, format("Exit Code = %d", t.value.exitstatus)
          end
          return JSON.parse(o.read)
        }
      rescue => exn
        raise ReportsError, exn_message(exn)
      end
    end

    # @private
    def exn_message(exn)
      return format("Process terminated abnormally: %s.", exn.message);
    end

  end
end