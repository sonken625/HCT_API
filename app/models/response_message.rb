class ResponseMessage < ApplicationRecord

  include FaradayCreator
  belongs_to :request_message


  before_validation :post_response,unless: :sent_response?


  private
  def sent_response?
    self.request_message.type == "SentRequestMessage"
  end

  def post_response
    resque_from_server_errors :response_message,"作成"do
      response = create_faraday.post "/response_messages" , response_message:{message_unique_id: self.request_message.message_unique_id,response_type:"json_response",params_string: self.params_string}
      logger.debug response.body
      unless response.success?
        errors.add :response_message, 'の作成に失敗しました。 error: ' + response.body.to_s
        throw :abort
      end
    end
  end


end
