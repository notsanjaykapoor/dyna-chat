# frozen_string_literal: true

require "helper"

describe "room" do
  include Minitest::Hooks

  around do |&block|
    DB.transaction(:rollback=>:always, :savepoint=>true, :auto_savepoint=>true) do
      super(&block)
    end
  end

  let!(:room) { Room.create(name: "room 1", timestamp: Time.now.utc) }

  describe "#create" do
    it "should create with valid params" do
      message = Message.create(
        data: {}.to_json,
        message_id: ULID.generate(),
        room_id: room.id,
        timestamp: Time.now.utc,
        user_id: "user",
      )

      assert_equal(message.valid?, true)
    end
  end

end
