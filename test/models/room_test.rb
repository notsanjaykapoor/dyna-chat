# frozen_string_literal: true

require "helper"

describe "room" do
  include Minitest::Hooks

  around do |&block|
    DB.transaction(:rollback=>:always, :savepoint=>true, :auto_savepoint=>true) do
      super(&block)
    end
  end

  describe "#create" do
    it "should create with valid params" do
      channel = Room.create(
        name: "name",
        timestamp: Time.now.utc,
      )

      assert_equal(channel.valid?, true)
    end
  end

  describe "#uniqueness" do
    describe "should not channel with duplicate name" do
      let(:params) do
        {
          name: "name",
          timestamp: Time.now.utc,
        }
      end

      let!(:room) { Room.create(params) }

      it "should throw error" do
        assert_raises(Sequel::ValidationFailed) do
          Room.create(params)
        end
      end
    end
  end

end
