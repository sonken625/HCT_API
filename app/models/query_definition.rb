class QueryDefinition < ApplicationRecord
  include FaradayCreator

  validates :search_key, presence:true, uniqueness: true
  validates :params_string,presence:true
  before_validation :generate_search_key, if:  Proc.new { |query_definition| query_definition.search_key.blank? }
  before_destroy :destroy_search_key

  def generate_search_key
    begin
      response = create_faraday().post "/query_definitions"

      if response.success?
        logger.debug response.body
        self.search_key = response.body["search_key"]
      else

        errors.add :search_key, 'の作成に失敗しました。error:'+ response.body.to_s
        throw :abort
      end

    rescue Faraday::Error::TimeoutError => e
      logger.debug e
      errors.add :search_key, 'の作成に失敗しました。HCSがタイムアウトしました。'
      throw :abort
    rescue Faraday::Error::ConnectionFailed=> e
      logger.debug e
      errors.add :search_key, 'の作成に失敗しました。HCSサーバーとの接続に失敗しました。'
      throw :abort
    rescue Faraday::Error::ClientError=> e
      logger.debug e
      errors.add :search_key, 'の作成に失敗しました。HCSサーバーの接続エラーです。'
      logger.debug e

    end



  end


  def update_search_key
    begin
    response = create_faraday.put "/query_definitions/#{self.search_key}/search_key"
    if response.success?
      logger.debug response.body
      self.update(search_key: response.body["search_key"])
    else
      errors.add :search_key, 'search_keyの更新に失敗しました。HCSエラーです。'
      false
    end

  rescue Faraday::Error::TimeoutError => e
    logger.debug e
    errors.add :search_key, 'の更新に失敗しました。HCSがタイムアウトしました。'
    throw :abort
  rescue Faraday::Error::ConnectionFailed=> e
    logger.debug e
    errors.add :search_key, 'の更新に失敗しました。HCSサーバーとの接続に失敗しました。'
    throw :abort
  rescue Faraday::Error::ClientError=> e
    logger.debug e
    errors.add :search_key, 'の更新に失敗しました。HCSサーバーの接続エラーです。'
    logger.debug e
    end
  end

  def destroy_search_key
    begin
      response = create_faraday.delete "/query_definitions/#{self.search_key}"
      if response.success?
        true
      else
        errors.add :search_key, 'の削除に失敗しました'
        throw :abort
      end

    rescue Faraday::Error::TimeoutError => e
      errors.add :search_key, 'の削除に失敗しました。HCSがタイムアウトしました。'
      throw :abort
    rescue Faraday::Error::ConnectionFailed=> e
      errors.add :search_key, 'の削除に失敗しました。HCSサーバーとの接続に失敗しました。'
      throw :abort
    rescue Faraday::Error::ClientError=> e
      errors.add :search_key, 'の削除に失敗しました。HCSサーバーの接続エラーです。'
      throw :abort
    end

  end
end
