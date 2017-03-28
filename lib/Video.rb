require 'httparty'

class Video
  include HTTParty

  format :json

  base_uri 'https://api.zype.com'

  def initialize
  end

  # This methods gets a list of videos from zype api.
  #
  # @param [nil]  No param
  # @return [String] Returns String with the video list
  def self.get_list()
    new()
    puts "potato1 de fuego"
    response = get('/videos', query: { app_key: ENV["app_key"] })
    puts response.inspect
    if response.success? || !response.nil?
      response["response"]
    else
      logger.debug response.inspect
    end
  end

  # This method get a specific video from zype api.
  #
  # @param [String] id The video's id
  # @return [String] Returns a String with the videos information and URL
  def self.get_video(id)
    puts "potato individual 1"
    response = get('/videos/'+id, query: { app_key: ENV["app_key"] })
    puts response
    puts "potato individual 2"
    if response.success? && !response.nil?
      response["response"]
    else
      puts response.inspect
    end
  end
end
