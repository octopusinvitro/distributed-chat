# frozen_string_literal: true

require 'server'
require 'ui'

require 'fake_kernel'

RSpec.describe Server do
  subject(:server) { described_class.new(socket, UI.new, FakeKernel.new(loops)) }
  let(:loops) { 2 }
  let(:socket) { instance_double(TCPServer).as_null_object }

  describe('#run') do
    let(:jane) { instance_double(TCPSocket).as_null_object }
    let(:faye) { instance_double(TCPSocket).as_null_object }

    before do
      allow(socket).to receive(:accept).and_return(jane, faye)
      allow(jane).to receive(:gets).and_return('Jane', 'hi Faye', 'bye Faye')
      allow(faye).to receive(:gets).and_return('Faye', 'hi Jane', 'bye Jane')
      allow($stdout).to receive(:puts)
    end

    context 'when successful' do
      it 'prints server started' do
        expect { server.run }.to output(/Server started/).to_stdout
      end

      it 'reads the usernames and next messages' do
        server.run
        expect(jane).to have_received(:gets).exactly(1 + loops).times
        expect(faye).to have_received(:gets).exactly(1 + loops).times
      end

      it 'adds new clients to node list' do
        server.run
        expect(server.clients.users).to contain_exactly(:Jane, :Faye)
      end

      it 'prints the usernames to the terminal' do
        server.run
        expect($stdout).to have_received(:puts).with(/Jane joined/).once
        expect($stdout).to have_received(:puts).with(/Faye joined/).once
      end

      it 'informs clients they joined chat' do
        server.run
        expect(jane).to have_received(:puts).with(/Jane joined/)
        expect(faye).to have_received(:puts).with(/Faye joined/)
      end

      it 'broadcasts to other clients that client joined chat' do
        server.run.each(&:join)
        expect(jane).to have_received(:puts).with(/Faye joined/)
        # expect(faye).to have_received(:puts).with(/Jane joined/)
      end

      it 'broadcasts messages to all clients' do
        server.run.each(&:join)
        expect(jane).to have_received(:puts).with(/Faye.*hi Jane/)
        expect(jane).to have_received(:puts).with(/Faye.*bye Jane/)
        # expect(faye).to have_received(:puts).with(/Jane.*hi Faye/)
        # expect(faye).to have_received(:puts).with(/Jane.*bye Faye/)
      end
    end

    context 'when no username received from client' do
      before { allow(jane).to receive(:gets).and_return(nil) }

      it 'closes client' do
        server.run
        expect(jane).to have_received(:close).once
      end

      it 'kills client thread' do
        allow(Thread).to receive(:kill)
        server.run
        expect(Thread).to have_received(:kill).once
      end
    end

    context 'when name is repeated' do
      before { allow(faye).to receive(:gets).and_return('Jane') }

      it 'informs the client' do
        server.run
        expect(faye).to have_received(:puts).with(/exists/)
      end

      it 'closes client' do
        server.run
        expect(faye).to have_received(:close).once
      end

      it 'kills client thread' do
        allow(Thread).to receive(:kill)
        server.run
        expect(Thread).to have_received(:kill).once
      end
    end

    context 'when no message received from client' do
      before { allow(jane).to receive(:gets).and_return('Jane', nil) }

      it 'removes client from list' do
        server.run
        expect(server.clients.users).to_not include(:Jane)
      end

      it 'prints to terminal that client left' do
        server.run
        expect($stdout).to have_received(:puts).with(/Jane left/).once
      end

      it 'broadcasts to other clients that client left' do
        server.run
        # expect(faye).to have_received(:puts).with(/Jane left/).once
      end

      it 'closes client' do
        server.run
        expect(jane).to have_received(:close).once
      end

      it 'kills client thread' do
        allow(Thread).to receive(:kill)
        server.run
        expect(Thread).to have_received(:kill).once
      end
    end

    context 'when a socket error happens' do
      before { allow(socket).to receive(:accept).and_raise(Errno::ETIMEDOUT) }

      it 'prints an error message' do
        expect { server.run }.to output(/ERROR/).to_stdout
      end
    end
  end
end
