# frozen_string_literal: true

require 'client_ui'

RSpec.describe ClientUI do
  subject(:client_ui) { described_class.new }

  let(:header) { instance_double(CursesUI::Header, display: nil) }
  let(:chatbox) { instance_double(CursesUI::Chatbox, print: nil) }
  let(:input) { instance_double(CursesUI::Input).as_null_object }
  let(:message) { CursesUI::Message.new }

  before do
    allow(CursesUI::Header).to receive(:new).and_return(header)
    allow(CursesUI::Chatbox).to receive(:new).and_return(chatbox)
    allow(CursesUI::Input).to receive(:new).and_return(input)

    client_ui.start('username', message)
  end

  describe '#start' do
    it 'displays the header' do
      expect(header).to have_received(:display)
    end
  end

  describe '#stop' do
    it 'stops curses' do
      allow(Curses).to receive(:close_screen)
      client_ui.stop
      expect(Curses).to have_received(:close_screen)
    end
  end

  describe '#print' do
    it 'prints message to chatbox' do
      client_ui.print('hello')
      expect(chatbox).to have_received(:print).with('hello')
    end

    it 'returns focus to user input box' do
      client_ui.print('hello')
      expect(input).to have_received(:focus)
    end
  end

  describe '#read' do
    def key(key)
      CursesUI::Key.new(key)
    end

    def enter
      CursesUI::Key::KEY_ENTER
    end

    def type(*keys)
      allow(input).to receive(:read).and_return(*keys)
    end

    context 'when a character is pressed' do
      before { type(key('h'), key('i'), key(enter)) }

      it 'builds the message character by character' do
        client_ui.read
        expect(message.to_s).to eq('hi')
      end

      it 'keeps message and input sizes in sync' do
        client_ui.read
        expect(input).to have_received(:size=).with(2)
      end
    end

    context 'when Enter key is pressed' do
      before { type(key('h'), key('i'), key('!'), key(enter)) }

      it 'prints message to chatbox' do
        client_ui.read
        expect(chatbox).to have_received(:print).with('<username> hi!')
      end

      it 'clears the input' do
        client_ui.read
        expect(input).to have_received(:clear)
      end

      it 'returns message' do
        expect(client_ui.read).to eq('hi!')
      end
    end

    context 'when left key is pressed' do
      let(:left) { Curses::KEY_LEFT }

      it 'moves left if there is space' do
        type(key('a'), key(left), key('h'), key(enter))
        client_ui.read
        expect(input).to have_received(:move_left)
        expect(message.to_s).to eq('ha')
      end

      it 'does nothing if there is no space' do
        type(key(left), key(enter))
        client_ui.read
        expect(input).to_not have_received(:move_left)
        expect(message.to_s).to eq('')
      end
    end

    context 'when right key is pressed' do
      let(:right) { Curses::KEY_RIGHT }
      let(:left) { Curses::KEY_LEFT }

      it 'moves right if there is space' do
        type(key('h'), key(left), key(right), key('a'), key(enter))
        client_ui.read
        expect(input).to have_received(:move_right)
        expect(message.to_s).to eq('ha')
      end

      it 'does nothing if there is no space' do
        type(key(right), key(enter))
        client_ui.read
        expect(input).to_not have_received(:move_right)
        expect(message.to_s).to eq('')
      end
    end

    context 'when up or down keys are pressed' do
      let(:up) { Curses::KEY_UP }
      let(:down) { Curses::KEY_DOWN }

      it 'does nothing and waits for next input' do
        type(key('h'), key(up), key('a'), key(down), key(enter))
        client_ui.read
        expect(message.to_s).to eq('ha')
      end
    end

    context 'when home key is pressed' do
      let(:home) { Curses::KEY_HOME }

      it 'moves to the start of the message' do
        type(key('e'), key('y'), key(home), key('h'), key(enter))
        client_ui.read
        expect(input).to have_received(:move_home)
        expect(message.to_s).to eq('hey')
      end
    end

    context 'when end key is pressed' do
      let(:fin) { Curses::KEY_END }
      let(:left) { Curses::KEY_LEFT }

      it 'moves to the end of the message' do
        type(key('h'), key('e'), key(left), key(fin), key('y'), key(enter))
        client_ui.read
        expect(input).to have_received(:move_end)
        expect(message.to_s).to eq('hey')
      end
    end

    context 'when backspace key is pressed' do
      let(:back) { Curses::KEY_BACKSPACE }
      let(:left) { Curses::KEY_LEFT }

      it 'deletes one character to the left' do
        type(key('b'), key('y'), key('e'), key(back), key(enter))
        client_ui.read
        expect(input).to have_received(:backspace)
        expect(message.to_s).to eq('by')
      end

      it 'updates input size' do
        type(key('b'), key('y'), key('e'), key(back), key(enter))
        client_ui.read
        expect(input).to have_received(:size=).with(2).twice
      end

      it 'does nothing if there is no character to the left' do
        type(key('h'), key('i'), key(left), key(left), key(back), key(enter))
        client_ui.read
        expect(input).to_not have_received(:backspace)
        expect(message.to_s).to eq('hi')
      end
    end

    context 'when delete key is pressed' do
      let(:delete) { Curses::KEY_DC }
      let(:left) { Curses::KEY_LEFT }

      it 'deletes one character to the right' do
        type(key('b'), key('y'), key('e'), key(left), key(delete), key(enter))
        client_ui.read
        expect(input).to have_received(:delete)
        expect(message.to_s).to eq('by')
      end

      it 'updates input size' do
        type(key('b'), key('y'), key('e'), key(left), key(delete), key(enter))
        client_ui.read
        expect(input).to have_received(:size=).with(2).twice
      end

      it 'does nothing if there is no character to the right' do
        type(key('h'), key('i'), key(delete), key(enter))
        client_ui.read
        expect(input).to_not have_received(:delete)
        expect(message.to_s).to eq('hi')
      end
    end

    context 'when interrupt happens' do
      before do
        allow(input).to receive(:read).and_raise(Interrupt)
        allow($stdout).to receive(:puts)
      end

      it 'stops curses' do
        allow(Curses).to receive(:close_screen)
        client_ui.read
        expect(Curses).to have_received(:close_screen)
      end

      it 'informs the user' do
        expect { client_ui.read }.to output(/closed/).to_stdout
      end
    end
  end

  describe '#format_message' do
    it 'appends username before user message' do
      expect(client_ui.format_message("hi\n", 'user')).to eq('<user> hi')
    end
  end
end
