# frozen_string_literal: true

require 'curses_ui/input'

RSpec.describe CursesUI::Input do
  subject(:input) { described_class.new(1, 20, 20) }
  let(:window) { instance_double(Curses::Window).as_null_object }

  before { allow(Curses::Window).to receive(:new).and_return(window) }
  after { Curses.close_screen }

  describe '#setup' do
    it 'sets the keypad' do
      input
      expect(window).to have_received(:keypad).with(true)
    end
  end

  describe '#focus' do
    it 'moves the cursor back to the beginning' do
      input.focus
      expect(window).to have_received(:move).with(described_class::MINIMUM_X, described_class::MINIMUM_Y)
    end
  end

  describe '#read' do
    it 'reads user input as a character' do
      allow(window).to receive(:getch).and_return('a')
      expect(input.read.to_s).to eq('a')
    end
  end

  describe '#clear' do
    it 'clears the window contents' do
      input.clear
      expect(window).to have_received(:clear)
    end
  end

  describe '#insert' do
    before do
      allow(window).to receive(:cury).and_return(0)
      allow(window).to receive(:curx).and_return(2)
    end

    it 'inserts character in position if moved left' do
      allow(window).to receive(:insch)
      input.move_left
      input.insert('a')
      expect(window).to have_received(:insch).with('a')
    end

    it 'inserts character in position if moved right' do
      allow(window).to receive(:insch)
      input.move_right
      input.insert('a')
      expect(window).to have_received(:insch).with('a')
    end

    it 'does nothing and lets curses handle inserts if did not move' do
      allow(window).to receive(:insch)
      input.insert('a')
      expect(window).to_not have_received(:insch).with('a')
    end
  end

  describe '#move_left' do
    it 'moves the cursor 1 character left' do
      allow(window).to receive(:cury).and_return(0)
      allow(window).to receive(:curx).and_return(2)
      input.move_left
      expect(window).to have_received(:setpos).with(0, 2 - 1)
    end
  end

  describe '#move_right' do
    it 'moves the cursor 1 character right' do
      allow(window).to receive(:cury).and_return(0)
      allow(window).to receive(:curx).and_return(2)
      input.move_right
      expect(window).to have_received(:setpos).with(0, 2 + 1)
    end
  end

  describe '#move_home' do
    it 'moves the cursor to the beginning' do
      allow(window).to receive(:cury).and_return(0)
      input.move_home
      expect(window).to have_received(:setpos).with(0, 0)
    end
  end

  describe '#move_end' do
    it 'moves the cursor to the end' do
      allow(window).to receive(:cury).and_return(0)
      input.size = 4
      input.move_end
      expect(window).to have_received(:setpos).with(0, input.size)
    end
  end

  describe '#backspace' do
    it 'deletes one character to the left' do
      input.backspace
      expect(window).to have_received(:delch)
    end
  end

  describe '#delete' do
    it 'deletes one character to the right' do
      input.delete
      expect(window).to have_received(:delch)
    end
  end
end
