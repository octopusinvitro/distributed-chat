# frozen_string_literal: true

class ClientList
  def initialize(mutex)
    @mutex = mutex
    @clients = {}
  end

  def add(username, client)
    return if clients[username]

    return if clients.values.find { |repeated| repeated == client }

    mutex.synchronize { clients[username] = client }
  end

  def remove(username)
    mutex.synchronize { clients.delete(username) }
  end

  def broadcastable(username)
    clients.except(username)
  end

  def users
    clients.keys
  end

  private

  attr_reader :clients, :mutex
end
