class ApplicationController < ActionController::Base
  skip_before_filter :verify_authenticity_token
  helper_method :authenticate!

  def authenticate!
    if params[:api_key]
      if User.where(api_key: params[:api_key]).any?
        sign_in(User.find_by(api_key: params[:api_key]), scope: :user)
      else
        render json: {:error => "Wrong API key"}
      end
    else
      authenticate_user!
    end
  end
end
