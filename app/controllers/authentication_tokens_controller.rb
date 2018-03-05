class AuthenticationTokensController< ApplicationController

    before_action :set_component, only: [:update, :destroy]

    def update
      token = @user.generate_authentication_token
      render json: {"token": token}.to_json
    end

    def destroy
      @user.delete_authentication_token
      render nothing: true
    end

    private
    def set_user
      @user =User.find(params[:user_id])
    end
  end
