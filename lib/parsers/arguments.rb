# frozen_string_literal: true

require 'ipaddr'
require 'optparse'

require_relative 'options'

module Parsers
  class Arguments
    MESSAGES = {
      banner: "\nUsage: ruby bin/app [options]",
      help: 'Prints this help.',
      address: "IP:port of the node to connect to. Default is #{Options.default.address}.",
      server: 'Set this node as the server. Default is not a server.'
    }.freeze

    def initialize
      @parser = OptionParser.new
      @options = Options.default

      setup_parser
    end

    def parse(arguments)
      parser.parse!(arguments)
      options
    rescue StandardError => e
      puts("ERROR: #{e.message}\n\n")
      print_help
    end

    private

    attr_reader :parser, :options

    def setup_parser
      set_banner
      read_help
      read_address
      read_server
    end

    def set_banner
      parser.banner = MESSAGES[:banner]
    end

    def read_help
      parser.on('-h', '--help', MESSAGES[:help]) { print_help }
    end

    def read_address
      parser.on('-a ADDRESS', '--address=ADDRESS', MESSAGES[:address]) do |address|
        ip, port = address.split(':')
        options.ip = IPAddr.new(ip).to_s
        options.port = Integer(port).to_s
      end
    end

    def read_server
      parser.on('-s', '--[no-]server', MESSAGES[:server]) do |server|
        options.server = server
      end
    end

    def print_help
      puts(parser)
      Kernel.exit
    end
  end
end
