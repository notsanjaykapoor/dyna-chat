# frozen_string_literal: true

class Room < ::Sequel::Model
  plugin :dirty
  plugin :validation_helpers

  def validate
    super
    validates_presence [:name, :timestamp]
    validates_unique :name
  end

  # scopes

  dataset_module do
  end

  def data
    super || {}
  end

  def messages
    Message.where(room_id: id)
  end

  def messages_count
    messages.count
  end

end
