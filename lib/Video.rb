require 'httparty'

class Video
  include HTTParty

  format :json

  base_uri 'api.zype.com'

  def self.get_list()
    get('/videos', query: { app_key: ENV["app_key"] })
  end

  def self.get_video(id)
    get('/videos/', query: { id: id })
  end
end
