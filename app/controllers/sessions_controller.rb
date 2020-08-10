class SessionsController < ApplicationController
  def new
    # Render login page
  end

  def create
    # Fetch corresponding user from db
    user = User.find_by username: params[:username]

    # If user exists, save the user id into the session
    session[:user_id] = user.id if user

    # Redirect to personal page
    redirect_to user
  end

  def destroy
    # Clear the session
    session[:user_id] = nil
    # Redirect to main page
    redirect_to :root
  end
end
