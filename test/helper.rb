# frozen_string_literal: true

require "minitest/autorun"
require "minitest/bang"
require "minitest/focus"
require "minitest/hooks/default"
require "minitest/rg"
require "rack/test"
require "spy/integration"
require "toys"

require "./boot"

MiniTest::Spec.register_spec_type(/.*/, Minitest::HooksSpec)

class Minitest::Spec
  include Rack::Test::Methods

  before :each do
  end

  after :each do
  end
end
