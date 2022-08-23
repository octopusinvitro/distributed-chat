# frozen_string_literal: true

require 'curses_ui/chatbox'

RSpec.describe CursesUI::Chatbox do
  subject(:chatbox) { described_class.new(20, 20, 0) }

  let(:border_size) { described_class::VERTICAL_BORDER.size }
  let(:top_height) { described_class::TOP_BORDER_HEIGHT }
  let(:window) { instance_double(Curses::Window).as_null_object }

  before { allow(Curses::Window).to receive(:new).and_return(window) }
  after { Curses.close_screen }

  describe '#setup' do
    before { allow(window).to receive(:cury).and_return(0) }

    it 'displays box' do
      described_class.new(42, 42, 42)
      expect(window).to have_received(:box).once
    end

    it 'moves cursor under box border' do
      described_class.new(1, 1, 1)
      expect(window).to have_received(:setpos).with(top_height, border_size).once
    end
  end

  describe '#print' do
    before { allow(window).to receive(:cury).and_return(0, 1, 2) }

    it 'prints every message in a new line respecting borders' do
      chatbox.print('foo')
      chatbox.print('bar')
      expect(window).to have_received(:setpos).with(0 + top_height, border_size).twice
      expect(window).to have_received(:setpos).with(1 + top_height, border_size).once
    end

    it 'prints message followed by a line' do
      chatbox.print('foo')
      expect(window).to have_received(:addstr).with(/foo\n/)
    end

    it 'reprints box to simulate scrolling' do
      chatbox.print('foo')
      expect(window).to have_received(:box).twice
    end
  end
end
