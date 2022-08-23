# frozen_string_literal: true

require 'socket'

require 'ui'

RSpec.describe UI do
  subject(:ui) { UI.new }

  describe '#ask_for_username' do
    it 'prints a prompt' do
      expect { ui.ask_for_username }.to output(/username: /).to_stdout
    end
  end

  describe '#gets' do
    it 'gets standard input without newline' do
      allow($stdin).to receive(:gets).and_return("foo\n")
      input = ui.gets
      expect(input).to eq('foo')
    end
  end

  describe '#puts' do
    it 'puts to standard output' do
      expect { ui.puts('foo') }.to output("foo\n").to_stdout
    end
  end

  describe '#print_error' do
    it 'formats error messages' do
      expect { ui.print_error('oh no') }.to output(/ERROR: oh no/).to_stdout
    end
  end

  describe '#print_server_started' do
    it 'prints server info' do
      server = instance_double(TCPServer)
      allow(server).to receive(:inspect).and_return('#<TCPServer:fd 6, AF_INET, 127.0.0.1, 3000>')

      expect { ui.print_server_started(server) }.to output(/127.0.0.1, 3000/).to_stdout
    end
  end

  describe '#print_user_joined' do
    it 'prints username and client info' do
      client = instance_double(TCPSocket)
      allow(client).to receive(:inspect).and_return('#<TCPSocket:fd 6, AF_INET, 127.0.0.1, 3000>')

      expect { ui.print_user_joined('username', client) }.to output(/username joined.*127.0.0.1, 3000/).to_stdout
    end
  end

  describe '#print_user_left' do
    it 'prints username left' do
      expect { ui.print_user_left('username') }.to output(/username left /).to_stdout
    end
  end

  describe '#user_joined_message' do
    it 'builds user-joined message' do
      expect(ui.user_joined_message('username')).to match(/username joined/)
    end
  end

  describe '#user_left_message' do
    it 'builds user-left message' do
      expect(ui.user_left_message('username')).to match(/username left/)
    end
  end

  describe '#client_ui' do
    it 'returns a client UI' do
      expect(ui.client_ui).to be_a(ClientUI)
    end
  end
end
