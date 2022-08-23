# frozen_string_literal: true

require 'curses'

module CursesUI
  class Chatbox
    VERTICAL_BORDER = '|'
    TOP_BORDER_HEIGHT = 1

    def initialize(height, width, top)
      @height = height
      @width = width
      @top = top

      setup
    end

    def print(message)
      move_cursor(chatbox.cury)
      chatbox.addstr(" #{message}\n")
      display_box
    end

    private

    attr_reader :height, :width, :top

    def setup
      chatbox.scrollok(true)
      display_box
      move_cursor(chatbox.cury + TOP_BORDER_HEIGHT)
    end

    def display_box
      chatbox.box(VERTICAL_BORDER, '-')
      chatbox.refresh
    end

    def move_cursor(y_position)
      chatbox.setpos(y_position, VERTICAL_BORDER.size)
    end

    def chatbox
      @chatbox ||= Curses::Window.new(height, width, top, 0)
    end
  end
end
