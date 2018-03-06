class ReceivedRequestMessagesController < ApplicationController
  before_action :set_received_request_message, only: [:show]
  before_action :set_query_definition, only: :index
  # GET /received_request_messages
  # GET /received_request_messages.json
  def index
    @received_request_messages = ReceivedRequestMessage.search_with_query_definition(@query_definition).order("created_at").limit(100)
  end

  # GET /received_request_messages/1
  # GET /received_request_messages/1.json
  def show
  end


  private
  def set_query_definition
    @query_definition = QueryDefinition.find_by_params_string(params[:params_string])
    # if @query_definition.nil?
    #   render json: {status: :error, error_code: :bad_request, message: "invalid search key"}
    #   return
    # end
    authorize! :read, @query_definition
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_received_request_message
    @received_request_message = ReceivedRequestMessage.find_by(message_unique_id: params[:request_message_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def received_request_message_params
    params.fetch(:received_request_message, {})
  end
end
