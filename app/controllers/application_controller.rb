class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    User.find_by_session_token(session[:token])
  end

  def login_user!
    session[:token] = @user.reset_session_token!
    @user.save
    redirect_to cats_url
  end

  def logged_in?
    if current_user
      redirect_to cats_path
    end
  end

  def not_logged_in?
    unless current_user
      redirect_to new_session_path
    end
  end
end
