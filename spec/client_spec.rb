# frozen_string_literal: true

require 'client'
require 'client_ui'
require 'ui'

require 'fake_kernel'

RSpec.describe Client do
  subject(:client) { described_class.new(server, ui, FakeKernel.new(2)) }

  let(:server) { instance_double(TCPSocket, puts: nil) }
  let(:ui) { UI.new }
  let(:client_ui) { instance_double(ClientUI).as_null_object }

  describe('#run') do
    before do
      allow(ui).to receive(:client_ui).and_return(client_ui)

      allow(server).to receive(:gets).and_return("joined\n", 'Eve: hi', 'Eve: bye')
      allow($stdin).to receive(:gets).and_return("Jane\n")
      allow(client_ui).to receive(:read).and_return('hello', 'bye')

      allow($stdout).to receive(:puts)
      allow($stdout).to receive(:print)
    end

    after { Curses.close_screen }

    it 'asks for username' do
      expect { client.run }.to output(/username: /).to_stdout
    end

    it 'sends username to network' do
      client.run
      expect(server).to have_received(:puts).with('Jane').once
    end

    it 'prints user joined' do
      expect { client.run }.to output(/joined/).to_stdout
    end

    it 'starts client UI' do
      client.run
      expect(client_ui).to have_received(:start).with('Jane')
    end

    it 'opens thread for sending to network' do
      client.run
      expect(server).to have_received(:puts).with('hello')
      expect(server).to have_received(:puts).with('bye')
    end

    it 'opens thread for receiving from network' do
      client.run
      expect(server).to have_received(:gets).exactly(3).times
    end

    it 'prints received message to client ui' do
      client.run
      expect(client_ui).to have_received(:print).with(/Eve: hi/)
    end

    it 'keeps receiving messages' do
      client.run
      expect(client_ui).to have_received(:print).with(/Eve: bye/)
    end

    context 'when disconnection from server happens' do
      before { allow(server).to receive(:gets).and_return(nil) }

      it 'stops client UI' do
        client.run
        expect(client_ui).to have_received(:stop)
      end

      it 'prints message to terminal' do
        expect { client.run }.to output(/#{UI::SERVER_DIED_ERROR}/).to_stdout
      end
    end
  end
end
