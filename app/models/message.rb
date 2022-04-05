# frozen_string_literal: true

class Message < ::Sequel::Model
  plugin :dirty
  plugin :validation_helpers

  def validate
    super
    validates_presence [:message_id, :room_id, :user_id, :timestamp]
    validates_unique :message_id
  end

  # scopes

  dataset_module do
    def from_eq(s)
      where(Sequel.lit("data->'message'->>'from' = ?", s))
    end
  end

  def data
    super || {}
  end

end
