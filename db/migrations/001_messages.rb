Sequel.migration do

  change do
    create_table(:rooms) do
      primary_key :id
      String :name, null: false
      column :timestamp, DateTime # timestamp
    end

    create_table(:messages) do
      primary_key :id
      String :data
      String :message_id, null: false
      Integer :room_id, null: false
      String :user_id, null: false
      column :timestamp, DateTime # timestamp
    end
  end

end
