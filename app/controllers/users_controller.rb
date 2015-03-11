class UsersController < ApplicationController
  before_action :logged_in?

  def new
    @user ||= User.new
  end

  def create
    @user = User.new(user_params)
    @user.reset_session_token!
    if @user.save
      login_user!
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
