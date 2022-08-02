# frozen_string_literal: true

require 'parsers/options'

RSpec.describe Parsers::Options do
  subject(:options) { described_class.default }

  it 'has an address' do
    expect(options.address).to eq('127.0.0.1:3000')
  end

  describe '#node' do
    before do
      allow(TCPSocket).to receive(:open)
      allow(TCPServer).to receive(:open)
    end

    it 'is a client factory by default' do
      expect(options.node).to be_a(Client)
    end

    it 'can create server nodes if specified' do
      options.server = true
      expect(options.node).to be_a(Server)
    end

    it 'passes the right IP and port to clients' do
      options.node
      expect(TCPSocket).to have_received(:open).with('127.0.0.1', '3000')
    end

    it 'passes the right IP and port to servers' do
      options.server = true

      options.node
      expect(TCPServer).to have_received(:open).with('127.0.0.1', '3000')
    end

    it 'informs user when no server running or specified' do
      mock_error(TCPSocket, Errno::ECONNREFUSED)
      expect { options.node }.to output(/Start a server/).to_stdout
    end

    it 'informs user when other errors happen' do
      options.server = true
      mock_error(TCPServer, StandardError.new('oh no'))
      expect { options.node }.to output(/oh no/).to_stdout
    end

    def mock_error(socket, error)
      allow($stdout).to receive(:puts)
      allow(Kernel).to receive(:exit)
      allow(socket).to receive(:open).and_raise(error)
    end
  end
end
