module SessionsHelper
  # Store in session variable the given user id
  #
  # @param [ActiveRecord::User] ActiveRecord::User - Model created in rails named User
  # @return [session] session variable
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns the ActiveRecord::User retrieve with user_id
  #
  # @return [ActiveRecord::User] ActiveRecord::User
  def current_user
    @current ||= User.find_by(id: session[:user_id])
  end

  # Returns true if current user is not nil, returns false if its nil
  #
  # @return [boolean]
  def logged_in?
    !current_user.nil?
  end

  # Deletes user_id from the session variable and set @current_user to nil
  #
  # @return [nil]
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
