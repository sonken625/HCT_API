json.extract! received_request_message, :id,:message_unique_id,:created_at, :updated_at
json.url received_request_message_url(received_request_message, format: :json)