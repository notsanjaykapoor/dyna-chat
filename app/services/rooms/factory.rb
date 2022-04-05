# frozen_string_literal: true

module Services
  module Rooms
    class Factory

      DEFAULT = "public"

      def initialize

        @struct = Struct.new(:code, :room_id, :errors)
      end

      def call
        struct = @struct.new(0, 0, [])

        room = Room.find(name: DEFAULT)

        if room.nil?
          room = Room.create(
            name: DEFAULT,
            timestamp: Time.now.utc,
          )
        end

        struct.room_id = room.id

        struct
      end

    end
  end
end
