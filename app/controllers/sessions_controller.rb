class SessionsController < ApplicationController
  before_action :already_signed_in_user, only: [:new]
  
  def new
  end
  
  def create
    user = User.find_by(username: user_params[:username].downcase)
    if user && user.authenticate(user_params[:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
  
  private
    def already_signed_in_user
      redirect_to current_user if signed_in?
    end
  
    def user_params
      params.require(:session).permit(:username, :password)
    end
end
