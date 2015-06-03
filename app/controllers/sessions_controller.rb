class SessionsController < ApplicationController
  skip_before_filter :check_session, :except => [:destroy]

  # session#destroy notes
  # destroys the cookie which stores the current_user id for session faking in app/controllers/application_controller.rb
  # once this is destroyed there is no current user and it redirects to the home page
  # routing info: HTTP GET to => /logout
  def destroy
    cookies.signed[:current_user_id] = nil
    redirect_to new_session_path
  end

  def new
    @users = User.all
  end

  def create
    user_id = params[:id]
    cookies.signed[:current_user_id] = user_id
    redirect_to root_url
  end
end