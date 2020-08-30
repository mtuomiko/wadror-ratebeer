class SessionsController < ApplicationController
  def new
    # Render login page
  end

  def create
    # Fetch corresponding user from db
    user = User.find_by username: params[:username]

    if user&.closed
      redirect_to signin_url, notice: 'Your account is closed, please contact admin'
    elsif user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user, notice: 'Welcome back!'
    else
      redirect_to signin_path, notice: 'Username or password failure'
    end
  end

  def destroy
    # Clear the session
    session[:user_id] = nil
    # Redirect to main page
    redirect_to :root
  end
end
