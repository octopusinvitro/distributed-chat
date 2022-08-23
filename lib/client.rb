# frozen_string_literal: true

class Client
  def initialize(server, ui, kernel = Kernel)
    @server = server
    @ui = ui
    @kernel = kernel

    Thread.abort_on_exception = true
    Thread.report_on_exception = false
  end

  def run
    client_ui.start(connect)
    [receive, send].each(&:join)
  rescue NoMethodError
    client_ui.stop
    ui.print_error(UI::SERVER_DIED_ERROR)
  end

  private

  attr_reader :server, :ui, :kernel

  def connect
    ui.ask_for_username
    username = ui.gets
    server.puts(username)
    ui.puts(server.gets.chomp)
    username
  end

  def receive
    Thread.new do
      kernel.loop do
        message = server.gets.chomp
        client_ui.print(message)
      end
    end
  end

  def send
    Thread.new do
      kernel.loop do
        message = client_ui.read
        server.puts(message)
      end
    end
  end

  def client_ui
    @client_ui = ui.client_ui
  end
end
