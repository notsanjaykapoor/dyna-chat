# frozen_string_literal: true

module Client
  class Request

    @@ids = []

    def self.add_id(id:)
      @@ids.push(id)
    end

    def self.ids
      @@ids
    end


  end
end
