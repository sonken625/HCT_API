module FaradayCreator
  extend ActiveSupport::Concern

  module ClassMethods
  end

  def create_faraday
    Faraday.new(url: 'http://localhost:3001',
                headers: {:Authorization => 'Token ' + ENV["HCS_AUTHENTICATION_TOKEN"], :Accept => 'application/json'},
                request: {
                    open_timeout: 5, # opening a connection
                    timeout: 10 # waiting for response
                }) do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.response :json, :content_type => /\bjson$/
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
  end

end