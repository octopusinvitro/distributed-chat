# frozen_string_literal: true

require 'socket'

require 'client_list'

RSpec.describe ClientList do
  subject(:clients) { described_class.new(Mutex.new) }
  let(:client) { instance_double(TCPSocket) }

  describe '#add' do
    it 'adds a new client to the list' do
      clients.add(:Username, client)
      expect(clients.users).to eq([:Username])
    end

    it 'synchronizes thread access' do
      mutex = instance_double(Mutex, synchronize: nil)
      clients = described_class.new(mutex)
      clients.add(:Username, client)
      expect(mutex).to have_received(:synchronize)
    end

    it 'does not add client to list if username exists' do
      clients.add(:Username, client)
      clients.add(:Username, instance_double(TCPSocket))
      expect(clients.users).to eq([:Username])
    end

    it 'does not add client to list if client exists' do
      clients.add(:Username, client)
      clients.add(:Another, client)
      expect(clients.users).to eq([:Username])
    end
  end

  describe '#remove' do
    it 'deletes client by username' do
      clients.add(:Username, client)
      clients.remove(:Username)
      expect(clients.users).to be_empty
    end

    it 'synchronizes thread access' do
      mutex = instance_double(Mutex, synchronize: nil)
      clients = described_class.new(mutex)
      clients.add(:Username, client)
      clients.remove(:Username)
      expect(mutex).to have_received(:synchronize).twice
    end
  end

  describe '#broadcastable' do
    it 'returns all clients except the provided' do
      clients.add(:Username, client)
      clients.add(:Another, instance_double(TCPSocket))
      expect(clients.broadcastable(:Another)).to eq(Username: client)
    end
  end
end
