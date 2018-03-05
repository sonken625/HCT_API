class SearchKeysController < ApplicationController
  before_action :set_query_definition

  def update
    if @query_definition.update_search_key
      render json: {search_key: @query_definition.search_key}.to_json
    end

  end


  private
    def set_query_definition
      @query_definition = QueryDefinition.find( params[:query_definition_id])
    end
end
