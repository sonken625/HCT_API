class ReceivedRequestMessage < RequestMessage
  belongs_to :query_definition
  before_validation :set_query_definition

  scope :search_with_query_definition, lambda { |query_definition|
    where(query_definition_id: query_definition.id) if query_definition.present?
  }

  private

  def set_query_definition
    if search_key.blank?
      errors.add :search_key,"が空です"
      throw :abort
    end
    query_definition = QueryDefinition.find_by_search_key(search_key)
    if query_definition
      self.query_definition = query_definition
    else
      errors.add :search_key,"が不正です"
      throw :abort
    end
  end

end
