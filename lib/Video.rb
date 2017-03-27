require 'httparty'

class Video
  include HTTParty

  format :json

  base_uri 'api.zype.com'

  def initialize
  end

  # This methods gets a list of videos from zype api.
  #
  # @param [nil]  No param
  # @return [String] Returns String with the video list
  def self.get_list()
    new()
    response = get('/videos', query: { app_key: ENV["client_id"] })
    if response.success? || !response.nil?
      response
    end
  end

  # This method get a specific video from zype api.
  #
  # @param [String] id The video's id
  # @return [String] Returns a String with the videos information and URL
  def self.get_video(id)
    get('/videos/', query: { id: id })
  end
end
