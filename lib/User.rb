require 'httparty'

class User
  include HTTParty

  format :json

  base_uri 'login.zype.com'


  # Init method of User Class.
  #
  # @param [response] Response object inherits from BasicObject. Httparty
  # class.
  # @return [User] User object is returned.
  def intialize(response)
    @access_token = response["access_token"]
    @expires_in = response["expires_in"]
    @refresh_token = response["refresh_token"]
    @scope = response["scope"]
    @created_at = response["created_at"]
    @token_type = response["token_type"]
  end


  # This method connects with the zype's api for authentication purpose
  # and returns User object.
  #
  # @param [String] user email introduced in login form
  # @param [String] pwd is the user password introduced in login form
  # @return [User] Initializated User object is return unless the request
  # is failed. In this case an error is raised.
  def self.auth_consumer(user, pwd)
    response = post('/oauth/token/', body: { client_id: ENV['client_id'],
      client_secret: ENV['client_secret'],
      username: user,
      password: pwd,
      grant_type: "password" }.to_json,
      headers: { 'Content-Type' => 'application/json'}
    )

    if response.success?
      new(response)
    else
      # TODO: create response in case the authentication is failed
    end
  end

  # This method refresh the User access token. Communicates with zype's api
  # and post the refresh token. An updated User object is returned.
  #
  # @param [String] refresh_token This token is stored when User Object is created.
  # @return [User] User Object
  def self.refresh_token(refresh_token)
    response = post('/oauth/token/', body: { client_id: ENV['client_id'],
      client_secret: ENV['client_secret'],
      refresh_token: self.refresh_token,
      grant_type: 'refresh_token' }
    )

    if response.success?
      # TODO: create response on success
    else
      # TODO: create response on fail
    end
  end

  # This method check for token status. It's connects with zype api and returns
  # a boolean
  # TODO: return a boolean
  # @param [nil]
  # @return [boolean?]
  def self.get_token_status()
    get('/oauth/token/info/', query: { access_token: self.access_token })
  end
end
