# frozen_string_literal: true

module Client
  module Chat
    class Identify

      MSG = "identify"

      def initialize(queue:, user_id:, old_id:, rid: ULID.generate)
        @queue = queue
        @user_id = user_id
        @old_id = old_id
        @rid = rid

        @struct = Struct.new(:code, :errors)
      end

      def call
        struct = @struct.new(0, [])

        @queue.enqueue({
          "message": MSG,
          "user_id": @user_id,
          "old_id": @old_id,
          "rid": @rid,
        })

        struct
      end

    end
  end
end
