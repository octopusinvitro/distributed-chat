# frozen_string_literal: true

require 'curses'

module CursesUI
  class Key
    KEY_ENTER = 10

    def initialize(key)
      @key = key
    end

    def to_s
      key.to_s
    end

    def left?
      key == Curses::KEY_LEFT
    end

    def right?
      key == Curses::KEY_RIGHT
    end

    def up?
      key == Curses::KEY_UP
    end

    def down?
      key == Curses::KEY_DOWN
    end

    def home?
      key == Curses::KEY_HOME
    end

    def end?
      key == Curses::KEY_END
    end

    def backspace?
      key == Curses::KEY_BACKSPACE
    end

    def delete?
      key == Curses::KEY_DC
    end

    def enter?
      key == KEY_ENTER
    end

    private

    attr_reader :key
  end
end
