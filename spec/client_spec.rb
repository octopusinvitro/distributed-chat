# frozen_string_literal: true

require 'client'
require 'ui'

require 'fake_kernel'

RSpec.describe Client do
  subject(:client) { described_class.new(server, UI.new, FakeKernel.new(2)) }
  let(:server) { instance_double(TCPSocket, puts: nil) }

  describe('#run') do
    before do
      allow(server).to receive(:gets).and_return("Eve: hi\n", "Eve: bye\n")
      allow($stdin).to receive(:gets).and_return("Jane\n", "hello\n")

      allow($stdout).to receive(:puts)
      allow($stdout).to receive(:print)
    end

    it 'opens thread for receiving from network' do
      client.run
      expect(server).to have_received(:gets).twice
    end

    it 'prints received message to terminal' do
      expect { client.run }.to output(/Eve: hi/).to_stdout
    end

    it 'keeps receiving messages' do
      expect { client.run }.to output(/Eve: bye/).to_stdout
    end

    it 'asks for username' do
      expect { client.run }.to output(/username: /).to_stdout
    end

    it 'sends username to network' do
      client.run
      expect(server).to have_received(:puts).with('Jane').once
    end

    it 'opens thread for sending to network' do
      client.run
      expect(server).to have_received(:puts).with('hello').once
    end

    it 'detects disconnection from server' do
      allow(server).to receive(:gets).and_return(nil)
      expect { client.run }.to output(/disconnected/).to_stdout
    end
  end
end
