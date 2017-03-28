class SessionsController < ApplicationController
  require 'Consumer'

  def new
  end

  def create
    if current_user.nil? || !current_user.logged_in?

    else

    end
    user = ApplicationRecord::User.find_by(email: params[:session][:email].downcase)
    if user
      puts "potato1"
      if Consumer.get_token_status(user.access_token)
        puts "potato2"
        log_in user
        # redirect_to videos_show_url, id: session["id"]
      else
        puts "potato3"
        if update_user_at_refresh_token(user.refresh_token, email)
          puts "potato4"
          log_in user
        else
          puts "potato5"
          redirect_to root_url
        end
      end
    else
      response = Consumer.auth_consumer(params[:session][:email], params[:session][:password])
      if response.success?
        # consumer = Consumer.new(response.parsed_response)
        # puts consumer
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
        render 'new'
      end
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  # def refresh_user(user, email)
  #   response = user.refresh_token()
  #   user.access_token = response["access_token"]
  #   user.expires_in = response["expires_in"]
  #   user.refresh_token = response["refresh_token"]
  #   user.scope = response["scope"]
  #   user.created_at = response["created_at"]
  #   user.token_type = response["token_type"]
  #
  #   update_user_at_refresh_token(user, email)
  # end
  #

  def log_user

  end

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
