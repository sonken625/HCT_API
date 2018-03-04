class AuthenticationTokensController< ApplicationController

    before_action :set_component, only: [:update, :destroy]

    def update
      token = @component.generate_authentication_token
      logger.debug(token)
      render json: {"token": token}.to_json
    end

    def destroy
      @component.delete_authentication_token
      render nothing: true
    end

    private
    def set_component
      @component =User.find(params[:user_id])
    end
  end
