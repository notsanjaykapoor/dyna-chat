require "async"
require "async/websocket/adapters/rack"

# boot app

require "./boot"

subject = "Websocket"

# create default room
Services::Rooms::Factory.new.call

# initialize rack app

app = lambda do |env|
  Async::WebSocket::Adapters::Rack.open(env, protocols: ["ws"]) do |connection|
    ::Services::Sockets::Connections.add(
      connection: connection
    )

    Console.logger.info(subject, "connection created : count #{::Services::Sockets::Connections.count}")

    # read messages from websocket
    while str_encoded = connection.read
      begin
        message = Oj.load(str_encoded)

        struct_parse = ::Services::Messages::Parse.new(
          message: message,
          connection: connection,
        ).call

        Console.logger.info(subject, "connections : count #{::Services::Sockets::Connections.count} : users #{::Services::Sockets::Connections.user_ids}")
      rescue => e

      end
    end
  ensure
    Console.logger.info(subject, "connection remove")

    ::Services::Sockets::Connections.remove(
      connection: connection
    )

    Console.logger.info(subject, "connection deleted : count #{::Services::Sockets::Connections.count} : users #{::Services::Sockets::Connections.users_count}")
  end
end

run app
