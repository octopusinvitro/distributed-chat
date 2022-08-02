# frozen_string_literal: true

class UI
  SERVER_MISSING_ERROR = 'Start a server first. Print help with -h.'
  SERVER_DIED_ERROR = 'Chat server has disconnected.'
  DUPLICATE_CLIENT_ERROR = 'This username already exists.'

  def ask_for_username
    $stdout.print('Enter the username: ')
  end

  def gets
    $stdin.gets.chomp
  end

  def puts(message)
    $stdout.puts(message)
  end

  def print_error(message)
    $stdout.puts("\nERROR: #{message}")
  end

  def print_server_started(server)
    $stdout.puts("Server started running at #{server.inspect}.")
  end

  def print_user_joined(username, client)
    $stdout.puts("#{user_joined_message(username)} from #{client.inspect}.")
  end

  def print_user_left(username)
    $stdout.puts(user_left_message(username))
  end

  def user_joined_message(username)
    "#{username} joined the chat"
  end

  def user_left_message(username)
    "#{username} left the chat."
  end

  def format_message(message, username)
    "<#{username}> #{message}"
  end
end
