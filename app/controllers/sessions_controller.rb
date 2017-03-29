class SessionsController < ApplicationController
  require 'Consumer'

  # Render /session/new.html.erb view for login and stores request source page
  #
  # @return [nil]
  def new
    session[:return_to] ||= request.referer
  end

  # Search for an already created user, if not, creates new user in DB and if
  # user credentials are valid it concedes permission to see the selected video
  #
  # @return [nil]
  def create
    if !logged_in?
      user = ApplicationRecord::User.find_by(email: params[:session][:email].downcase)
      if user
        if Consumer.get_token_status(user.access_token)
          log_in user
          redirect_to videos_show_url(id: session.delete(:video_id))
        else
          destroy
          if update_user_at_refresh_token(user.refresh_token, email)
            log_in user
            redirect_to videos_show_url(id: session(:video_id))
          else
            redirect_to root_url
          end
        end
      else
        response = Consumer.auth_consumer(params[:session][:email], params[:session][:password])
        if response.success?
          user = User.create(access_token: response.parsed_response["access_token"],
                              expires_in: response.parsed_response["expires_in"],
                              refresh_token: response.parsed_response["refresh_token"],
                              scope: response.parsed_response["scope"],
                              created_at: response.parsed_response["created_at"],
                              token_type: response.parsed_response["token_type"],
                              email: params[:session][:email]
                            )
          if user.save
            log_in user
          else
            render 'new'
          end
        else
          puts "POTATO"
          puts response.inspect
          flash[:error] = 'Invalid email/password combination'
          render action: 'new'
        end
      end
    else
      redirect_to videos_show_url(id: session.delete(:video_id))
    end
  end

  def choose
    render 'choose'
  end

  # Destroy the current session (Logout) and returns to root url
  #
  # @return [nil]
  def destroy
    log_out
    redirect_to root_url
  end

  # Aux method that updates user info when token is refreshed in zype's api
  #
  # @param [string] refresh_token string stored when user log in
  # @param [email] email user email
  # @return [boolean] returns true if user is updated and false if not
  def update_user_at_refresh_token(refresh_token, email)
    response = Consumer.refresh_token(user.refresh_token)
    if response.success?
      db_user = ApplicationRecord::User.find_by_email(email)
      db_user.access_token = response["access_token"]
      db_user.expires_in = response["expires_in"]
      db_user.refresh_token = response["refresh_token"]
      db_user.created_at = response["created_at"]
      db_user.token_type = response["token_type"]
      if db_user.save?
        true
      else
        false
      end
    else
      false
    end
  end

end
