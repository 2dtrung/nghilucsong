class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :destroy]
  #before_action :correct_user
  before_action :admin_user,     only: :destroy
  def show
    @user = User.find(params[:id])
  end
  def index
    @user = User.all 
  end
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to @user
    else
      render 'new'
    end
  end
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    #def correct_user
      #@user = User.find(params[:id])
      #redirect_to(root_url) unless current_user?(@user)
    #end

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
