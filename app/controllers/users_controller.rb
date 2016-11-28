class UsersController < ApplicationController
  before_action :already_signed_in_user, only: [:new, :create]
  before_action :sign_in_user, only: [:edit, :update, :index, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @articles = @user.articles.paginate(per_page: 10, page: params[:page])
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      sign_in @user
      flash[:success] = 'Welcome to the Photo Blog!'
      redirect_to @user
    else
      render 'new'
    end
  end

  def update
    if @user.update(user_params)
      sign_in @user   #no need resign in, said update cookie in book
      flash[:success] = 'Profile updated.'
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
    
    def already_signed_in_user
      redirect_to root_path if signed_in?
    end
    
    def correct_user
      redirect_to root_path unless current_user?(@user)
    end
    
    def admin_user
      redirect_to root_path unless current_user.admin? && !current_user?(@user)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :password, :nickname, :password_confirmation)
    end
end
