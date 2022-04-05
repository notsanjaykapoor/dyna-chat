require "async"
require "async/io"
require "base58"
require "oj"
require "openssl"
require "roda"
require "sequel"
require "ulid"

subject = "Boot::Kernel"

Console.logger.info(subject, "starting")

::Sequel.extension(:fiber_concurrency)
::Sequel.datetime_class = Time
::Sequel.default_timezone = :utc

require "./boot/database"
require "./boot/json"
require "./boot/secret"

Boot::Secret.new.call

struct_boot_database = Boot::Database.new.call

Boot::Json.new.call

# initialize db global object

DB = struct_boot_database.connection

Console.logger.info(subject, "completed")
