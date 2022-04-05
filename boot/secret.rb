# frozen_string_literal: true

require "dotenv"

module Boot
  class Secret

    def initialize
      @struct = Struct.new(:code, :dot_files, :errors)
    end

    def call
      struct = @struct.new(0, [], [])

      struct.dot_files = _dot_files

      Dotenv.load(*struct.dot_files)

      Console.logger.info(self, "env files loaded #{struct.dot_files}")

      struct
    end

    protected

    def _dot_files
      dot_file = ["./.env", ENV["RACK_ENV"]].compact.join(".")

      [dot_file].select{ |file| File.exist?(file) }
    end

  end
end
