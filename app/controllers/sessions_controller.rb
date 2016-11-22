class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(username: user_params[:username].downcase)
    if user && user.authenticate(user_params[:password])
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
  end
  
  private
    def user_params
      params.require(:session).permit(:username, :password)
    end
end
