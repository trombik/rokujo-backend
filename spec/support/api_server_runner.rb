require "socket"
require "timeout"

# A runner to run token analyzer
module ApiServerRunner
  def self.port
    ENV.fetch("ROKUJO_ANALYZER_PORT", 8000).to_i
  end

  def self.host
    ENV.fetch("ROKUJO_ANALYZER_HOST", "127.0.0.1")
  end

  @api_pid = nil

  def self.start
    return if running? || port_open?

    @api_pid = spawn(
      cmd,
      out: "/dev/null",
      err: "/dev/null"
    )

    wait_for_server
  end

  def self.cmd
    "cd vendor/rokujo-analyzer && uv run gunicorn main:app -c gunicorn_config.py"
  end

  def self.stop
    return unless @api_pid

    Process.kill("TERM", @api_pid)
    Process.wait(@api_pid)
    @api_pid = nil
  rescue Errno::ESRCH
    @api_pid = nil
  end

  def self.running?
    !!@api_pid
  end

  def self.port_open?
    TCPSocket.new(host, port).close
    true
  rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
    false
  end

  def self.wait_for_server
    Timeout.timeout(10) do
      loop do
        break if port_open?

        sleep 0.1
      end
    end
  rescue Timeout::Error
    warn "[ApiServerRunner] Failed to start API server on port #{port} within 10 seconds."
    stop
    exit 1
  end
end
