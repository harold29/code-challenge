class VideosController < ApplicationController
  require 'Video'

  # This method renders zype's video list on /video/index.html.erb
  #
  # @return [json] returns a video list in json format
  def index
    # video = Video.new()
    @video_list = Video.get_list()
  end

  # This method shows a selected video
  #
  # @return [nil]
  def show
    @video = Video.get_video(params[:id])
    @vid_id = params[:id]
    if @video["suscription_required"]
      if logged_in?
        render 'show'
      else
        session[:video_id] = @vid_id
        redirect_to choose_url and return
        # TODO: render user_login screen
      end
    else
      render 'show'
    end
  end
end
