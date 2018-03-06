# frozen_string_literal: true

class RequestMessage < ApplicationRecord
  include FaradayCreator
  validates :message_unique_id, presence: true, :uniqueness =>{:scope=> :type}
  validates :search_key, presence: true
  validates :type, presence: true

  has_many :response_messages

  def to_param
    message_unique_id
  end
end
