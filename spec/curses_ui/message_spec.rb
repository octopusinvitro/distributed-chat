# frozen_string_literal: true

require 'curses_ui/message'

RSpec.describe CursesUI::Message do
  subject(:message) { described_class.new }

  describe '#to_s' do
    it 'returns message' do
      expect(message.to_s).to eq('')
    end
  end

  describe '#insert' do
    it 'adds character in position' do
      %w[h e l l o].each { |character| message.insert(character) }
      expect(message.to_s).to eq('hello')
    end
  end

  describe '#move_left' do
    it 'moves 1 character left' do
      %w[c a r t].each { |character| message.insert(character) }
      message.move_left
      message.insert('e')
      expect(message.to_s).to eq('caret')
    end
  end

  describe '#move_right' do
    it 'moves 1 character right' do
      %w[c a r t].each { |character| message.insert(character) }
      2.times { message.move_left }
      message.move_right
      message.insert('e')
      expect(message.to_s).to eq('caret')
    end
  end

  describe '#move_home' do
    it 'moves to the beginning of the message' do
      %w[c a r t].each { |character| message.insert(character) }
      message.move_home
      message.insert('e')
      expect(message.to_s).to eq('ecart')
    end
  end

  describe '#move_end' do
    it 'moves to the end of the message' do
      %w[c a r t].each { |character| message.insert(character) }
      message.move_end
      message.insert('e')
      expect(message.to_s).to eq('carte')
    end
  end

  describe '#can_move_left?' do
    let(:word) { 'hello' }

    before { word.split('').each { |character| message.insert(character) } }

    it 'detects it can' do
      expect(message.can_move_left?).to eq(true)
    end

    it 'detects it can not' do
      word.size.times { message.move_left }
      expect(message.can_move_left?).to eq(false)
    end
  end

  describe '#can_move_right?' do
    let(:word) { 'goodbye' }

    before { word.split('').each { |character| message.insert(character) } }

    it 'detects it can' do
      message.move_left
      expect(message.can_move_right?).to eq(true)
    end

    it 'detects it can not' do
      expect(message.can_move_right?).to eq(false)
    end
  end

  describe '#backspace' do
    let(:word) { 'cart' }

    before { word.split('').each { |character| message.insert(character) } }

    it 'deletes 1 character to the left of the cursor' do
      message.move_left
      message.backspace
      expect(message.to_s).to eq('cat')
    end

    it 'deletes first character' do
      (word.size - 1).times { message.move_left }
      message.backspace
      expect(message.to_s).to eq('art')
    end

    it 'deletes last character' do
      message.backspace
      expect(message.to_s).to eq('car')
    end
  end

  describe '#delete' do
    let(:word) { 'cart' }

    before { word.split('').each { |character| message.insert(character) } }

    it 'deletes 1 character to the right of the cursor' do
      2.times { message.move_left }
      message.delete
      expect(message.to_s).to eq('cat')
    end

    it 'deletes first character at beginning of string' do
      word.size.times { message.move_left }
      message.delete
      expect(message.to_s).to eq('art')
    end

    it 'deletes last character' do
      message.move_left
      message.delete
      expect(message.to_s).to eq('car')
    end
  end

  describe '#size' do
    it 'returns the size of the string' do
      word = 'cart'
      word.split('').each { |character| message.insert(character) }
      expect(message.size).to eq(word.size)
    end
  end

  describe '#clear' do
    it 'clears the message and position' do
      %w[h e l l o].each { |character| message.insert(character) }
      message.clear
      message.insert('a')
      expect(message.to_s).to eq('a')
    end
  end
end
