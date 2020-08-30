class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    return nil if session[:user_id].nil?

    User.find(session[:user_id])
  end

  def ensure_that_signed_in
    redirect_to signin_url, notice: 'You should be signed in' if current_user.nil?
  end

  def require_admin
    redirect_back fallback_location: root_url, notice: 'You need to be admin to perform this action' if !current_user&.admin
  end
end
