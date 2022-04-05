# frozen_string_literal: true

require "helper"

describe "socket_connections" do
  include Minitest::Hooks

  describe "#add" do
    it "add connection with link to user" do
      ::Services::Sockets::Connections.add(
        connection: :connection_1
      )

      ::Services::Sockets::Connections.user_add(
        connection: :connection_1,
        user_id: "user-1",
      )

      user_connections = ::Services::Sockets::Connections.user_get(user_id: "user-1")
      users_count = ::Services::Sockets::Connections.users_count

      assert_equal(user_connections, [:connection_1])
      assert_equal(users_count, 1)
    end
  end

  describe "#remove" do
    it "remove connection and link to user" do
      ::Services::Sockets::Connections.add(
        connection: :connection_1
      )

      ::Services::Sockets::Connections.user_add(
        connection: :connection_1,
        user_id: "user-1",
      )

      ::Services::Sockets::Connections.user_remove(
        connection: :connection_1,
        user_id: "user-1",
      )

      user_connections = ::Services::Sockets::Connections.user_get(user_id: "user-1")
      users_count = ::Services::Sockets::Connections.users_count

      assert_equal(user_connections, [])
      assert_equal(users_count, 1)

      ::Services::Sockets::Connections.remove(
        connection: :connection_1
      )

      users_count = ::Services::Sockets::Connections.users_count

      assert_equal(users_count, 0)
    end
  end

end
