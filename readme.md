### Assumptions

I used the example message conversation to come up with certain assumptions/constraints.

Users can use the chat system as anonymous users (User B in example).  Optionally, users can use the /name command to name their client, and can do so at any point in the chat.

The act of optionally naming the chat/user/client made the concept of defining users difficult, so I opted not to have a users table in my database design.

### Setup

Install ruby 3

https://www.ruby-lang.org/en/documentation/installation/

Install gems

```
bundle install
```

Run database migrations

```
bundle exec toys db-migrate --version 1
bundle exec toys db-migrate --version 1 --env test
```

Run tests

```
rake test
```

Start chat server

```
./chat-server
```

Start chat client

```
./chat-client
```

### Chat Server

The chat server uses websockets to manage client connections.  Each client message is first persisted to the database and then broadcast to all connected websocket clients (including the sender).

The sqlite database has 2 tables, rooms and messages.  By default all messages are placed in the single default "public" room.  

### Chat client

The chat client connects to the server via websocket and uses this bi-directional link to send and receive messages.  The client terminal interface interleaves user input and incoming websocket messages.
