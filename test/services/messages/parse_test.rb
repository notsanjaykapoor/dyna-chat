# frozen_string_literal: true

require "helper"

describe "message_parse" do
  include Minitest::Hooks

  around do |&block|
    DB.transaction(:rollback=>:always, :savepoint=>true, :auto_savepoint=>true) do
      super(&block)
    end
  end

  describe "#message" do
    let!(:msg) do
      {
        "message" => "message",
        "data" => "hi there",
        "rid" => ULID.generate,
        "user_id" => "user-1",
      }
    end

    it "should persist message and broadcast to all users" do
      spy_broadcast = Spy.on_instance_method(
        ::Services::Sockets::Broadcast,
        :call
      ).and_return(0)

      message_count = Message.count

      struct_parse = ::Services::Messages::Parse.new(
        message: msg,
        connection: :connection_1
      ).call

      assert_equal(0, struct_parse.code)
      assert_equal(message_count+1, Message.count)
      assert_equal(1, spy_broadcast.calls.count)
    end
  end

end
