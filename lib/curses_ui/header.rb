# frozen_string_literal: true

require 'curses'

module CursesUI
  class Header
    STYLE = 10
    TITLE = 'Distributed chat (press Ctrl + C to exit)'

    def initialize(height, width)
      @height = height
      @width = width

      setup
    end

    def display
      header.color_set(STYLE)
      header.addstr(TITLE.center(Curses.cols))
      header.refresh
      header.close
    end

    private

    attr_reader :height, :width

    def setup
      Curses.start_color
      Curses.init_pair(STYLE, Curses::COLOR_BLACK, Curses::COLOR_GREEN)
    end

    def header
      @header ||= Curses::Window.new(height, width, 0, 0)
    end
  end
end
