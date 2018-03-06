# frozen_string_literal: true

module FaradayCreator
  extend ActiveSupport::Concern

  module ClassMethods
  end

  def create_faraday
    token= Rails.env ==  'development' ? ENV['HCS_AUTHENTICATION_TOKEN'] : ENV['HCS_AUTHENTICATION_TOKEN_PRO']
    url =  Rails.env==  'development' ?  ENV['HCS_SERVER_IP'] : 'http://localhost:3201'
    Faraday.new(url:url,
                headers: { Authorization: 'Token ' + token, Accept: 'application/json' },
                request: {
                  open_timeout: 5, # opening a connection
                  timeout: 10 # waiting for response
                }) do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.response :json, content_type: /\bjson$/
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
  end

  def resque_from_server_errors(attribute_name,action_name)
    yield
  rescue Faraday::Error::TimeoutError => e
    logger.debug e
    errors.add attribute_name, "の#{action_name}に失敗しました。HCSがタイムアウトしました。"
    throw :abort
  rescue Faraday::Error::ConnectionFailed => e
    logger.debug e
    errors.add attribute_name, "の#{action_name}に失敗しました。HCSサーバーとの接続に失敗しました。"
    throw :abort
  rescue Faraday::Error::ClientError => e
    logger.debug e
    errors.add attribute_name, "の#{action_name}に失敗しました。HCSサーバーの接続エラーです。"
    throw :abort
  end
end
