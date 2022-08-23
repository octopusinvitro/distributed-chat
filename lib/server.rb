# frozen_string_literal: true

require_relative 'client_list'

class Server
  ERRORS = [
    Errno::EPIPE,
    Errno::ETIMEDOUT,
    Errno::ECONNRESET,
    Errno::ECONNABORTED
  ].freeze

  attr_reader :clients

  def initialize(server, ui, kernel = Kernel)
    @server = server
    @ui = ui
    @kernel = kernel

    @clients = ClientList.new(Mutex.new)
  end

  def run
    ui.print_server_started(server)

    threads = []
    kernel.loop do
      threads << Thread.start(server.accept) { |client| connect(client) }
    end
    threads.each(&:join)
  rescue *ERRORS => e
    ui.print_error(e.message)
  end

  private

  attr_reader :server, :ui, :kernel

  def connect(client)
    received = client.gets
    return error(client) unless received

    username = received.chomp.to_sym
    return duplicate_error(client) unless clients.add(username, client)

    report_user_joined(username, client)
    start_chat(username, client)
  end

  def start_chat(username, client)
    kernel.loop do
      received = client.gets
      break client_error(username, client) unless received

      message = ui.client_ui.format_message(received, username)
      broadcast(username, message)
    end
  end

  def duplicate_error(client)
    client.puts(UI::DUPLICATE_CLIENT_ERROR)
    error(client)
  end

  def client_error(username, client)
    clients.remove(username)
    report_user_left(username)
    error(client)
  end

  def error(client)
    client.flush
    client.close
    Thread.kill(Thread.current)
    nil
  end

  def report_user_joined(username, client)
    ui.print_user_joined(username, client)
    client.puts(ui.user_joined_message(username))
    broadcast(username, ui.user_joined_message(username))
  end

  def report_user_left(username)
    ui.print_user_left(username)
    broadcast(username, ui.user_left_message(username))
  end

  def broadcast(username, message)
    clients.broadcastable(username).each { |_, socket| socket.puts(message) }
  end
end
