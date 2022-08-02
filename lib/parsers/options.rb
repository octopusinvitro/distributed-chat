# frozen_string_literal: true

require_relative '../client'
require_relative '../server'
require_relative '../ui'

module Parsers
  Options = Struct.new(:ip, :port, :server) do
    def self.default
      new('127.0.0.1', '3000', false)
    end

    def address
      [ip, port].join(':')
    end

    def node
      return Server.new(server_socket, ui) if server

      Client.new(client_socket, ui)
    rescue Errno::ECONNREFUSED
      error_and_exit(UI::SERVER_MISSING_ERROR)
    rescue StandardError => e
      error_and_exit(e.message)
    end

    private

    def server_socket
      TCPServer.open(ip, port)
    end

    def client_socket
      TCPSocket.open(ip, port)
    end

    def ui
      @ui ||= UI.new
    end

    def error_and_exit(message)
      ui.print_error(message)
      Kernel.exit
    end
  end
end
