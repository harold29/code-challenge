class UsersController < ApplicationController
  # Description of method
  #
  # @return [Type] description of returned object
  def new
    @user = User.new
  end

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
