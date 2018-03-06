json.extract! sent_request_message, :id, :message_unique_id,:created_at, :updated_at
json.url sent_request_message_url(sent_request_message, format: :json)
