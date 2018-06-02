class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy, :correct_user]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  
  def index
    # @users = User.paginate(page: params[:page])
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
  def show
    # redirect_to root_url and return unless 
  end
  
  def new
    @user = User.new
  end
  
  def create 
    @user = User.new(user_params)
    if @user.save
      # log_in @user
      # UserMailer.account_activation(@user).deliver_now
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account'
      redirect_to root_url
      # flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  
  end
  
  def update
   
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = 'User deleted'
    redirect_to users_url
  end

  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # Before Filters
    
    # Confirms a logged in user
    def logged_in_user
      unless logged_in?
        # store_location
        flash[:danger] = "Please log in to perform this action"
        redirect_to login_url
      end
    end
    
    # Confirms the correct user
    def correct_user
      # @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # find user:
    def find_user
      @user = User.find(params[:id])
    end
    
    # Confirms an admin user
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
