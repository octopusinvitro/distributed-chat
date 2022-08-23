# frozen_string_literal: true

require 'curses_ui/header'

RSpec.describe CursesUI::Header do
  subject(:header) { described_class.new(20, 20) }
  let(:window) { instance_double(Curses::Window).as_null_object }

  before { allow(Curses::Window).to receive(:new).and_return(window) }
  after { Curses.close_screen }

  describe '#display' do
    it 'prints a centered title' do
      allow(Curses).to receive(:cols).and_return(described_class::TITLE.size + 2)
      header.display
      expect(window).to have_received(:addstr).with(" #{described_class::TITLE} ")
    end

    it 'closes the window when finished' do
      header.display
      expect(window).to have_received(:close).once
    end
  end
end
