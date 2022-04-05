# frozen_string_literal: true

module Services
  module Messages
    class Replay

      def initialize(connection:, limit: 10)
        @connection = connection
        @limit = limit

        @struct = Struct.new(:code, :errors)
      end

      def call
        struct = @struct.new(0, [])

        message_query = Message.order(Sequel.desc(:timestamp)).limit(@limit).reverse

        message_query.each do |message|
          object = {
            message: "message",
            user_id: message.user_id,
            data: message.data,
          }

          ::Services::Sockets::Send.new(
            connection: @connection,
            message: object,
          ).call
        end

        struct
      end

    end
  end
end
