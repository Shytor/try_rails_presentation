class UsersController < ApplicationController
skip_before_filter :check_session, :only => [:new, :create]

  # users#index notes
  # The index method is in effect the home page of our app and combines multiple actions. The @users instance
  # variable is in reality the "index action" it is responsible for gathering all the users so they can be
  # displayed on the page. the @new_user is for the form for creating a new user. nothing happens with this object unless that form is submitted.
  # The @messages varibale is essentially the messages index acction. It gets all the messages so they can be displayed by the page.
  # This action will render the "app/views/users/index.htm.erb" by default so that is where all this data gets sent.
  # routing info: HTTP GET to => /users
  def index
    @users = User.all
    @messages = Message.all
  end

  # users#show notes
  # this represent the only real sub page of our app. Clicking on a user or their avatar in the ui will take you here
  # Each link to a user passes an id param (params[:id] evaluates to the value of this parameter) so when this action is called we
  # will always have that parameter. We use it to define the owner of the current page under @owner. It gets a list of all messages for that
  # user and saves them to @messages and creates a @new_message object for use by the new message form
  # routing info: HTTP GET to => /users/1
  def show
    @owner = User.find(params[:id])
    @messages = @owner.messages.all
    @new_message = Message.new
  end

  # users#create notes
  # This action recieves the data from the new user form and creates a user based off of it. There is no view for it, it just renders :index(really the home page)
  # it handles two cases. If the user is successfully created it sets the current user and redirects to the show page for that user. If it fails it sends you back to the
  # home page with and returns the same user back to the form along with its validation errors so the user can try to create a new user again.
  # routing info: HTTP POST to => /users
  def create
    @user = User.new(user_params)
    if @user.save
      params[:current_user_id] = @user.id
      set_current_user_id
      redirect_to @user, notice: 'User was successfully created.'
    else
      @users = User.all
      @new_user = @user
      @errors = @user.errors
      @messages = Message.all
      render :index
    end
  end

  def new
    @user = User.new
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :current_user_id)
  end

end
