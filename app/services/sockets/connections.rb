# frozen_string_literal: true

module Services
  module Sockets
    class Connections

      # global connections set
      @@connections = Set.new

      # global mapping of users to connections
      @@users = Hash.new

      def self.add(connection:)
        @@connections.add(connection)
      end

      def self.count
        @@connections.size
      end

      def self.remove(connection:)
        @@connections.delete(connection)

        # update users mapping

        @@users.each_pair do |user_id, connections|
          if connections.include?(connection)
            @@users[user_id] = connections - [connection]
          end
        end

        _users_gc
      end

      def self.user_add(connection:, user_id:)
        @@users[user_id] ||= []
        @@users[user_id].push(connection)
      end

      def self.user_get(user_id:)
        @@users[user_id] || []
      end

      def self.user_remove(connection:, user_id:)
        connection_list = @@users[user_id]

        if connection_list.blank?
          return 0
        end

        @@users[user_id] = connection_list - [connection]

        _users_gc

        0
      end

      def self.user_ids
        @@users.keys
      end

      def self.users
        @@users
      end

      def self.users_count
        @@users.keys.size
      end

      def self._users_gc
        @@users.each_pair do |user_id, connections|
          if connections.size.zero?
            # garbage collect
            @@users.delete(user_id)
          end
        end
      end

    end
  end
end
