# frozen_string_literal: true

module Client
  module Chat
    class Who

      MSG = "who"

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
