# frozen_string_literal: true

class SentRequestMessage < RequestMessage
  before_validation :post_request_message

  private
  def post_request_message
    resque_from_server_errors(:request_message, '作成') do
      response = create_faraday.post '/request_messages',
                                     request_message:
                                         {
                                             search_key: search_key
                                         }

      if response.success?
        self.message_unique_id = response.body['message_unique_id']
      else
        errors.add :request_message, 'の作成に失敗しました。 error: ' + response.body.to_s
        throw :abort
      end
    end
  end
end
