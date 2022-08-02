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
    ui.ask_for_username
    [receive, send].each(&:join)
  rescue NoMethodError
    ui.print_error(UI::SERVER_DIED_ERROR)
  end

  private

  attr_reader :server, :ui, :kernel

  def receive
    Thread.new do
      kernel.loop do
        message = server.gets.chomp
        ui.puts(message)
      end
    end
  end

  def send
    Thread.new do
      kernel.loop do
        message = ui.gets
        server.puts(message)
      end
    end
  end
end
