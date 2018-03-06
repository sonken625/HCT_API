namespace :sync_to_hcs do

  task :sync_response => :environment do
    logger = Logger.new('log/sync_to_hct.log')
    loop do
      puts "start"
      SentRequestMessage.select("search_key").group("search_key").each do |value|
        latest_request = SentRequestMessage.order("created_at").where(search_key: value.search_key ).last
        puts latest_request.message_unique_id

        response  = create_faraday.get "/response_messages?message_unique_id=#{latest_request.message_unique_id}&latest_id=#{latest_request.response_messages&.last&.on_hcs_id}"
        if response.success?
          puts response.body.to_s
          response.body.each do |res|
            ResponseMessage.create!(on_hcs_id: res["id"], params_string: res["params_string"] ,request_message: latest_request)
          end
        else
          logger.debug response.body.to_s
          puts response.body.to_s
        end
      rescue Faraday::Error::TimeoutError => e
        logger.debug e
        puts e
      rescue Faraday::Error::ConnectionFailed => e
        logger.debug e
        puts e
      rescue Faraday::Error::ClientError => e
        logger.debug e
        puts e
      end
      sleep 2
    end
  end

  task :sync_request => :environment do
    logger = Logger.new('log/sync_to_hct.log')
    loop do
      QueryDefinition.all.each do |query|
        latest_request = query.received_request_messages.order(:created_at).last
        response = create_faraday.get "/request_messages?search_key=#{query.search_key}&message_unique_id=#{latest_request&.message_unique_id}"
        if response.success?
          puts response.body.to_s

          response.body.each do |req|
            ReceivedRequestMessage.create!(message_unique_id: req["message_unique_id"], query_definition: query,search_key: query.search_key)
          end
        else

          logger.debug response.body.to_s
          puts response.body.to_s
          next
        end

        rescue Faraday::Error::TimeoutError => e
          logger.debug e
          puts e
        rescue Faraday::Error::ConnectionFailed => e
          logger.debug e
          puts e
        rescue Faraday::Error::ClientError => e
          logger.debug e
          puts e
      end

      sleep 2
    end
  end

  def create_faraday
    token= Rails.env ==  'development' ? ENV['HCS_AUTHENTICATION_TOKEN'] : ENV['HCS_AUTHENTICATION_TOKEN_PRO']
    Faraday.new(url: Rails.env==  'development' ? 'http://localhost:3001': 'http://localhost:3201',
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

end
