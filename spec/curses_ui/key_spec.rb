# frozen_string_literal: true

require 'curses_ui/key'

RSpec.describe CursesUI::Key do
  describe '#to_s' do
    it 'returns key as string' do
      expect(described_class.new(1).to_s).to eq('1')
    end
  end

  describe '#left?' do
    it('detects it is') { it_is(Curses::KEY_LEFT, :left?) }
    it('detects it is not') { it_is_not('a', :left?) }
  end

  describe '#right?' do
    it('detects it is') { it_is(Curses::KEY_RIGHT, :right?) }
    it('detects it is not') { it_is_not('a', :right?) }
  end

  describe '#up?' do
    it('detects it is') { it_is(Curses::KEY_UP, :up?) }
    it('detects it is not') { it_is_not('a', :up?) }
  end

  describe '#down?' do
    it('detects it is') { it_is(Curses::KEY_DOWN, :down?) }
    it('detects it is not') { it_is_not('a', :down?) }
  end

  describe '#home?' do
    it('detects it is') { it_is(Curses::KEY_HOME, :home?) }
    it('detects it is not') { it_is_not('a', :home?) }
  end

  describe '#end?' do
    it('detects it is') { it_is(Curses::KEY_END, :end?) }
    it('detects it is not') { it_is_not('a', :end?) }
  end

  describe '#backspace?' do
    it('detects it is') { it_is(Curses::KEY_BACKSPACE, :backspace?) }
    it('detects it is not') { it_is_not('a', :backspace?) }
  end

  describe '#delete?' do
    it('detects it is') { it_is(Curses::KEY_DC, :delete?) }
    it('detects it is not') { it_is_not('a', :delete?) }
  end

  describe '#enter?' do
    it('detects it is') { it_is(described_class::KEY_ENTER, :enter?) }
    it('detects it is not') { it_is_not('a', :enter?) }
  end

  def it_is(key, method)
    expect(described_class.new(key).send(method)).to eq(true)
  end

  def it_is_not(key, method)
    expect(described_class.new(key).send(method)).to eq(false)
  end
end
