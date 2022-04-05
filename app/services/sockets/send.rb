# frozen_string_literal: true

module Services
  module Sockets
    class Send

      #
      # broadcast message to the specified user connections
      #

      def initialize(connection:, message:)
        @connection = connection
        @message = message

        @str_encoded = Oj.dump(@message)
      end

      def call
        Console.logger.info(self, "message #{@message}")

        begin
          @connection.write(@str_encoded)
          @connection.flush
        rescue => e
          Console.logger.error(e)
        end
      end

    end
  end
end
