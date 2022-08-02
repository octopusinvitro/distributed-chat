# frozen_string_literal: true

require 'chat'
require 'client'
require 'ui'

RSpec.describe Chat do
  subject(:chat) { described_class.new(node, UI.new) }
  let(:node) { instance_double(Client, run: nil) }

  it 'runs a node' do
    chat.run
    expect(node).to have_received(:run)
  end

  it 'captures user interruption' do
    allow(node).to receive(:run).and_raise(Interrupt.new)

    allow(Kernel).to receive(:exit)
    chat.run
    expect(Kernel).to have_received(:exit).with(described_class::EXIT_CODE)
  end

  it 'captures other errors' do
    allow(node).to receive(:run).and_raise(StandardError.new('oh no'))
    expect { chat.run }.to output(/oh no/).to_stdout
  end
end
