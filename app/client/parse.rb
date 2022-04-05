# frozen_string_literal: true

module Client
  class Parse

    def initialize(message:)
      @message = message

      @message_name = @message["message"]

      @struct = Struct.new(:code, :output, :exit, :errors)
    end

    def call
      struct = @struct.new(0, "", 0, [])

      if @message_name[/hello/]
        struct.output = "> #{_user_name} joined the chat"
      elsif @message_name[/exit/]
        struct.output = "> #{_user_name} left the chat"
        struct.exit = 1
      elsif @message_name[/message/]
        struct.output = "#{_user_name}: #{@message["data"]}"
      end

      struct
    end

    protected

    def _user_name
      if @message["user_id"].length == 26 && @message["user_id"][/[0-9A-Z]{26}/]
        "user #{@message["user_id"]}"
      else
        @message["user_id"]
      end
    end

  end
end
