# frozen_string_literal: true

module CursesUI
  class Message
    def initialize
      clear
    end

    def to_s
      message
    end

    def insert(character)
      @message = message.dup.insert(position, character)
      @position += 1
    end

    def move_left
      @position -= 1
    end

    def move_right
      @position += 1
    end

    def move_home
      @position = 0
    end

    def move_end
      @position = size
    end

    def can_move_left?
      position.positive?
    end

    def can_move_right?
      position < message.size
    end

    def backspace
      @position -= 1
      delete
    end

    def delete
      message.slice!(position)
    end

    def size
      message.size
    end

    def clear
      @message = ''
      @position = 0
    end

    private

    attr_reader :message, :position
  end
end
