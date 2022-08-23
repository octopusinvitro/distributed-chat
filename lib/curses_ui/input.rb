# frozen_string_literal: true

require 'curses'

require_relative 'key'

module CursesUI
  class Input
    MINIMUM_X = 1
    MINIMUM_Y = 1

    attr_accessor :size

    def initialize(height, width, top)
      @height = height
      @width = width
      @top = top

      @moved = false
      @size = 0

      setup
    end

    def focus
      input.move(MINIMUM_X, MINIMUM_Y)
      input.refresh
    end

    def read
      CursesUI::Key.new(input.getch)
    end

    def clear
      input.clear
      @moved = false
    end

    def insert(character)
      input.insch(character) if moved
    end

    def move_left
      @moved = true
      input.setpos(input.cury, input.curx - 1)
    end

    def move_right
      @moved = true
      input.setpos(input.cury, input.curx + 1)
    end

    def move_home
      input.setpos(input.cury, 0)
    end

    def move_end
      input.setpos(input.cury, size)
    end

    def backspace
      delete
    end

    def delete
      input.delch
    end

    private

    attr_reader :height, :width, :top, :moved

    def setup
      input.keypad(true)
      input.scrollok(true)
      input.refresh
    end

    def input
      @input ||= Curses::Window.new(height, width, top, 0)
    end
  end
end
