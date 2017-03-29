class UsersController < ApplicationController
  # Creates but not store the ActiveRecord::User and renders the user/new.html.erb
  #
  # @return [ActiveRecord::User]
  def new
    @user = User.new
  end

  # Creates a new ActiveRecord::User and store it in the database. If User is stored
  # without errors the user is logged in and flash welcome message. If user is not
  # stored without errors renders new view.
  #
  #
  # @return [ActiveRecord:User] 
  def create
    @user = User.new(params[:user])
    if @user.save
      log_in @user
      flash[:success] = "Welcome!"
      #TODO: if save is successful redirect to video
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :passsword, :password_confirmation)
  end
end
