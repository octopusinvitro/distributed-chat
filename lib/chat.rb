# frozen_string_literal: true

class Chat
  EXIT_CODE = 130

  def initialize(node, ui)
    @node = node
    @ui = ui
  end

  def run
    node.run
  rescue Interrupt
    Kernel.exit(EXIT_CODE)
  rescue StandardError => e
    ui.print_error(e.message)
  end

  private

  attr_reader :node, :ui
end
