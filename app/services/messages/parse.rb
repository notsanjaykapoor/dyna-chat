# frozen_string_literal: true

module Services
  module Messages
    class Parse

      def initialize(message:, connection:)
        @message = message
        @connection = connection

        @message_name = @message["message"].to_s

        @struct = Struct.new(:code, :errors)
      end

      def call
        struct = @struct.new(0, [])

        Console.logger.info(self, "#{@message}")

        begin
          if @message_name[/exit/]
            struct.code = _parse_exit
          elsif @message_name[/hello/]
            struct.code = _parse_hello
          elsif @message_name[/identify/]
            struct.code = _parse_identify
          elsif @message_name[/message/]
            struct.code = _parse_message
          end
        rescue => e
          Console.logger.error(self, e)
        end

        struct
      end

      protected

      def _parse_exit
        if @connection.nil? || @message["user_id"].blank?
          # whoops
          return -1
        end

        # broadcast message to all users

        ::Services::Sockets::Broadcast.new(
          message: @message,
          user_ids: ::Services::Sockets::Connections.user_ids,
        ).call

        # unlink user from connection

        ::Services::Sockets::Connections.user_remove(
          connection: @connection,
          user_id: @message["user_id"],
        )

        0
      end

      def _parse_hello
        if @connection.nil? || @message["user_id"].blank?
          # whoops
          return -1
        end

        ::Services::Sockets::Connections.user_add(
          connection: @connection,
          user_id: @message["user_id"],
        )

        # broadcast message to all users

        ::Services::Sockets::Broadcast.new(
          message: @message,
          user_ids: ::Services::Sockets::Connections.user_ids,
        ).call

        # replay mssages for this user

        ::Services::Messages::Replay.new(
          connection: @connection
        ).call

        0
      end

      def _parse_identify
        if @connection.nil? || @message["user_id"].blank?
          # whoops
          return -1
        end

        ::Services::Sockets::Connections.user_add(
          connection: @connection,
          user_id: @message["user_id"],
        )

        ::Services::Sockets::Connections.user_remove(
          connection: @connection,
          user_id: @message["old_id"],
        )

        0
      end

      def _parse_message
        # save message

        Message.create(
          data: @message["data"],
          message_id: @message["rid"],
          room_id: Room.first.id,
          timestamp: Time.now.utc,
          user_id: @message["user_id"],
        )

        # broadcast message to all users

        ::Services::Sockets::Broadcast.new(
          message: @message,
          user_ids: ::Services::Sockets::Connections.user_ids,
        ).call
      end

    end
  end
end
