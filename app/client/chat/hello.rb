# frozen_string_literal: true

module Client
  module Chat
    class Hello

      MSG = "hello"

      def initialize(queue:, user_id:, rid: ULID.generate)
        @queue = queue
        @user_id = user_id
        @rid = rid

        @struct = Struct.new(:code, :errors)
      end

      def call
        struct = @struct.new(0, [])

        @queue.enqueue({
          "message": MSG,
          "user_id": @user_id,
          "rid": @rid,
        })

        struct
      end

    end
  end
end
