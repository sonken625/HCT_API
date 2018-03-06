class ResponseMessagesController < ApplicationController
  before_action :set_request_message , only:[:index,:create,:new]
  before_action :set_response_message, only: [:show]

  # GET /response_messages
  # GET /response_messages.json
  def index
    @response_messages = @request_message.response_messages
    respond_to do |format|
      format.html { raise ActionController::RoutingError.new('Not Found') }
      format.json {}
    end
  end

  # GET /response_messages/1
  # GET /response_messages/1.json
  def show
  end

  # GET /response_messages/new
  def new
    @response_message = ResponseMessage.new
  end

  # POST /response_messages
  # POST /response_messages.json
  def create
    @response_message = ResponseMessage.new(response_message_params)
    @response_message.request_message = @request_message
    respond_to do |format|
      if @response_message.save
        format.html { redirect_to @request_message, notice: 'Response message was successfully created.' }
        format.json { render :show, status: :created, location: @response_message }
      else
        format.html { render :new }
        format.json { render json: @response_message.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_response_message
      @response_message = ResponseMessage.find(params[:id])
    end

  def set_request_message
    if request.path_info.start_with?("/sent")

      @request_message =SentRequestMessage.find_by_message_unique_id(params[:request_message_id]) or not_found
    else
      @request_message =ReceivedRequestMessage.find_by_message_unique_id(params[:request_message_id]) or not_found
    end

  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def response_message_params
      params.fetch(:response_message, {}).permit(:params_string)
    end
end
