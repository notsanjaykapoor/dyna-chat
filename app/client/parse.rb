# frozen_string_literal: true

module Client
  class Parse

    def initialize(message:, request_ids:)
      @message = message
      @request_ids = request_ids

      @message_name = @message["message"]
      @message_rid = @message["rid"]

      @struct = Struct.new(:code, :output, :exit, :errors)
    end

    def call
      struct = @struct.new(0, "", 0, [])

      if @message_name[/hello/]
        struct.output = "> #{_user_name} joined the chat"
      elsif @message_name[/exit/]
        struct.output = "> #{_user_name} left the chat"

        # mark the exit flag iff this client sent exit
        if @request_ids.include?(@message_rid)
          struct.exit = 1
        end
      elsif @message_name[/message/]
        struct.output = "#{_user_name}: #{@message["data"]}"
      elsif @message_name[/who/]
        struct.output = "#{@message_name}: #{@message["user_ids"].join(",")}"
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
