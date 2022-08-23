# frozen_string_literal: true

require 'curses'

require_relative 'curses_ui/chatbox'
require_relative 'curses_ui/header'
require_relative 'curses_ui/input'
require_relative 'curses_ui/message'

class ClientUI
  SCREEN_WIDTH = Curses.cols
  HEADER_HEIGHT = FOOTER_HEIGHT = 1
  MAIN_HEIGHT = Curses.lines - HEADER_HEIGHT - FOOTER_HEIGHT

  def start(username, message = CursesUI::Message.new)
    @username = username
    @message = message

    display_header
    setup_chatbox
    setup_input
  end

  def stop
    Curses.close_screen
  end

  def print(message)
    chatbox.print(message)
    input.focus
  end

  def read
    message.clear
    read_message
  rescue Interrupt
    stop
    puts('Connection closed.')
  end

  def format_message(message, client = username)
    "<#{client}> #{message.chomp}"
  end

  private

  attr_reader :username, :message, :chatbox, :input

  def read_message # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    while (key = input.read)
      return enter if key.enter?

      next move_left if key.left?
      next move_right if key.right?
      next if key.up?
      next if key.down?
      next move_home if key.home?
      next move_end if key.end?
      next backspace if key.backspace?
      next delete if key.delete?

      insert(key.to_s)
    end
  end

  def enter
    chatbox.print(format_message(message.to_s))
    input.clear
    message.to_s
  end

  def move_left
    [message, input].each(&:move_left) if message.can_move_left?
  end

  def move_right
    [message, input].each(&:move_right) if message.can_move_right?
  end

  def move_home
    [message, input].each(&:move_home)
  end

  def move_end
    [message, input].each(&:move_end)
  end

  def backspace
    [message, input].each(&:backspace) if message.can_move_left?
    update_size
  end

  def delete
    [message, input].each(&:delete) if message.can_move_right?
    update_size
  end

  def insert(character)
    message.insert(character)
    input.insert(character)
    update_size
  end

  def update_size
    input.size = message.size
  end

  def display_header
    CursesUI::Header.new(HEADER_HEIGHT, SCREEN_WIDTH).display
  end

  def setup_chatbox
    @chatbox = CursesUI::Chatbox.new(
      Curses.lines - HEADER_HEIGHT - FOOTER_HEIGHT, SCREEN_WIDTH, HEADER_HEIGHT
    )
  end

  def setup_input
    @input = CursesUI::Input.new(FOOTER_HEIGHT, SCREEN_WIDTH, Curses.lines - FOOTER_HEIGHT)
  end
end
