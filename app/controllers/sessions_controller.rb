class SessionsController < ApplicationController
  def new
  end
  
  # def create
  #   ?user = User.find_by(email: params[:session][:email].downcase)
  #   if ?user && user.authenticate(params[:session][:password])
  #     log_in ?user
  #     params[:session][:remember_me] == '1' ? remmember(?user) : forget(?user)
  #     redirect_to ?user
  #   else
  #     flash.now[:danager] = 'Invalid email/password combination'
  #     render 'new'
  #   end
  # end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        # remember user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to user
      # redirect_back_or user
      else
        message = 'Account not activated'
        message += 'Check you email for the activation link'
        flash.now[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
