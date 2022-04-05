# frozen_string_literal: true

module Boot
  class Database

    def initialize
      @struct = Struct.new(:code, :connection, :errors)
    end

    def call
      struct = @struct.new(0, nil, [])

      Console.logger.info(self, "")

      begin
        # create connection
        struct.connection = ::Sequel.connect(ENV["DATABASE_URL"])
      rescue ::Sequel::DatabaseConnectionError => e
        # create database
        db = ::Sequel.connect(ENV["DATABASE_CONN"])
        db_name = ENV["DATABASE_NAME"]
        db.execute("create database #{db_name}")

        Console.logger.info(self, "created database #{db_name}")

        # create connection
        struct.connection = ::Sequel.connect(ENV["DATABASE_URL"])
      end

      struct
    end

  end
end
