class SessionsController < ApplicationController
  before_action :logged_in?, only: [:new, :create]

  def new
    @user ||= User.new
  end

  def create
    @user = User.find_by_credentials(session_params)
    unless @user.nil?
      login_user!
    else
      flash.now[:errors] = ["Bad username or password"]
      @user = User.new(session_params)
      render :new
    end
  end

  def destroy
    current_user.reset_session_token!
    session[:token] = nil
    redirect_to new_user_path
  end

  private

  def session_params
    params.require(:user).permit(:username, :password)
  end
end
