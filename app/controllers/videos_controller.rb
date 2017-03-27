class VideosController < ApplicationController
  require 'Video'

  def index
    # video = Video.new()
    @video_list = Video.get_list()["response"]
  end

  def show
    @video = Video.get_video(params[:id])
    if @video["suscription_required"]
      # TODO: render user_login screen
    else
      render 'show'
    end
  end
end
