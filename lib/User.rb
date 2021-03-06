require 'httparty'

class Consumer
  include HTTParty

  format :json

  base_uri 'login.zype.com'


  # Init method of Consumer Class.
  #
  # @param [response] Response object inherits from BasicObject. Httparty
  # class.
  # @return [Consumer] Consumer object is returned.
  def intialize(response)
    @access_token = response["access_token"]
    @expires_in = response["expires_in"]
    @refresh_token = response["refresh_token"]
    @scope = response["scope"]
    @created_at = response["created_at"]
    @token_type = response["token_type"]
  end


  # This method connects with the zype's api for authentication purpose
  # and returns Consumer object.
  #
  # @param [String] user email introduced in login form
  # @param [String] pwd is the user password introduced in login form
  # @return [Consumer] Initializated Consumer object is return unless the request
  # is failed. In this case an error is raised.
  def self.auth_consumer(user, pwd)
    response = post('/oauth/token/', body: { client_id: ENV['client_id'],
      client_secret: ENV['client_secret'],
      username: user,
      password: pwd,
      grant_type: "password" }.to_json,
      headers: { 'Content-Type' => 'application/json'}
    )
    puts "poteito"
    puts response.inspect
    
    if response.success?
      new(response)
    else
      # TODO: create response in case the authentication is failed
    end
  end

  # This method refresh the Consumer access token. Communicates with zype's api
  # and post the refresh token. An updated Consumer object is returned.
  #
  # @param [String] refresh_token This token is stored when Consumer Object is created.
  # @return [Consumer] Consumer Object
  def self.refresh_token()
    response = post('/oauth/token/',
      body: { client_id: ENV['client_id'],
      client_secret: ENV['client_secret'],
      refresh_token: self.refresh_token,
      grant_type: 'refresh_token' }
    )
    if response.success?
      # TODO: create response on success
      self.access_token = response["access_token"]
      self.expires_in = response["expires_in"]
      self.refresh_token = response["refresh_token"]
      self.scope = response["scope"]
      self.created_at = response["created_at"]
      self.token_type = response["token_type"]
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
    response = get('/oauth/token/info/', query: { access_token: self.access_token })
    if response["expires_in_seconds"] <= 0
      false
    else
      true
    end
  end
end
