class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  # json でのリクエストの場合CSRFトークンの検証をスキップ
  skip_before_action :verify_authenticity_token, if: -> {request.format.json?}
  # jsonの場合トークンによる認証
  prepend_before_action :authenticate_user_from_token!, if: -> {request.format.json?}

  prepend_before_action :authenticate_admin! ,if: -> {request.format.html?}

  # 権限無しのリソースにアクセスしようとした場合
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to main_app.root_url, alert: exception.message }
      format.json { render json: {message: exception.message}, status: :unauthorized }
    end
  end


  # トークンによる認証
  def authenticate_user_from_token!

    authenticate_or_request_with_http_token do |token, options|
      user = User.find_by_authentication_token(token)

      #タイミング攻撃対策
      if user && Devise.secure_compare(user.authentication_token, token)
        sign_in(User.find(user.id), scope: :user,store: false)
      end

      user.present?
    end
  end


  def current_ability
    if current_admin
      @current_ability ||= Ability.new(current_admin, true)
    else
      logger.debug(request.format.json?)
      @current_ability ||= Ability.new(current_user, false)
    end

  end


  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end



  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end
