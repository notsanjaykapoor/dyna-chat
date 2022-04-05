# frozen_string_literal: true

module Services
  module Sockets
    class Broadcast

      #
      # broadcast message to the specified user connections
      #

      def initialize(message:, user_ids: [])
        @message = message
        @user_ids = user_ids

        @str_encoded = Oj.dump(@message)
      end

      def call
        Console.logger.info(self, "user_ids #{@user_ids} message #{@message}")

        @user_ids.each do |user_id|
          connections = ::Services::Sockets::Connections.user_get(
            user_id: user_id
          )

          connections.each do |connection|
            begin
              connection.write(@str_encoded)
              connection.flush
            rescue => e
              Console.logger.error(e)
            end
          end
        end
      end

    end
  end
end
