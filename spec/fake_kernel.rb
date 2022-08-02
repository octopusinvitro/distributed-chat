# frozen_string_literal: true

class FakeKernel
  def initialize(times)
    @times = times
  end

  def loop(&block)
    times.times(&block)
  end

  private

  attr_reader :times
end
