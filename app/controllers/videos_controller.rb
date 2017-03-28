class VideosController < ApplicationController
  require 'Video'

  def index
    # video = Video.new()
    logger.debug "potato0"
    @video_list = Video.get_list()
  end

  def show
    @video = Video.get_video(params[:id])
    @vid_id = params[:id]
    if !@video.nil? && !@video["suscription_required"] && !current_user.logged_in?
      session[:video_id] = @vid_id
      redirect_to login_url, video_id: and return
      # TODO: render user_login screen
    else
      render 'show'
    end
  end
end
