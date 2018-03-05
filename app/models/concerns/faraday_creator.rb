module FaradayCreater
  extend ActiveSupport::Concern

  module ClassMethods
    def create_faraday
      return Faraday.new(:url => 'http://localhost:3000',:headers => {'Authorization' => 'Token ' + ENV["HCS_AUTHENTICATION_TOKEN"] ,'Accept'=> 'application/json'}) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end
  end


end