class QueryDefinition < ApplicationRecord
  include FaradayCreator

  validates :search_key, presence:true, uniqueness: true
  validates :params_string,presence:true
  before_validation :generate_search_key, if:  Proc.new { |query_definition| query_definition.search_key.blank? }
  before_destroy :destroy_search_key
  has_many :received_request_messages

  def generate_search_key
    resque_from_server_errors :search_key,"作成" do
      response = create_faraday.post "/query_definitions"
      if response.success?
        logger.debug response.body
        self.search_key = response.body["search_key"]
      else

        errors.add :search_key, 'の作成に失敗しました。error:'+ response.body.to_s
        throw :abort
      end
    end
  end

  def update_search_key
    resque_from_server_errors :search_key,"更新" do
      response = create_faraday.put "/query_definitions/#{self.search_key}/search_key"
      if response.success?
        logger.debug response.body
        update(search_key: response.body["search_key"])
      else
        errors.add :search_key, 'search_keyの更新に失敗しました。HCSエラーです。'
        false
      end
    end
  end

  def destroy_search_key
    resque_from_server_errors :search_key,"削除" do
      response = create_faraday.delete "/query_definitions/#{self.search_key}"
      if response.success?
        true
      else
        errors.add :search_key, 'の削除に失敗しました error:'+ response.body.to_s
        throw :abort
      end
    end
  end
end
