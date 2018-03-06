class SentRequestMessagesController < ApplicationController
  before_action :set_request_message, only: [:show]

  # GET /request_messages
  # GET /request_messages.json
  def index
    @sent_request_messages = SentRequestMessage.includes(:response_messages).order("created_at").limit(100)
  end

  # GET /request_messages/1
  # GET /request_messages/1.json
  def show

  end

  # GET /request_messages/new
  def new
    @sent_request_message = SentRequestMessage.new
  end


  # POST /request_messages
  # POST /request_messages.json
  def create
    @sent_request_message = SentRequestMessage.new(request_message_params)

    respond_to do |format|
      if @sent_request_message.save
        format.html { redirect_to @sent_request_message, notice: 'Request message was successfully created.' }
        format.json { render :show, status: :created, location: @sent_request_message }
      else
        format.html { render :new }
        format.json { render json: @sent_request_message.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request_message
      logger.debug params[:request_message_id]
      @sent_request_message = SentRequestMessage.find_by(message_unique_id: params[:request_message_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def request_message_params
      params.require(:sent_request_message).permit(:search_key)
    end
end
