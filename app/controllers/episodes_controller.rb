class EpisodesController < ApplicationController
  before_action :authenticate_user!, :tv_show_exists?

  def index
    @tv_show = TvShow.find(params[:tv_show_id])
    @episodes = Episode.where(tv_show_id: @tv_show.id)
    render json: @episodes
  end

  def show
    @tv_show = TvShow.find(params[:tv_show_id])
    @episode = Episode.where(id: params[:id], tv_show_id: @tv_show.id).first
    render json: @episode
  end

  def create
    @tv_show = TvShow.find(params[:tv_show_id])
    @episode = Episode.new(episode_params)
    @episode.tv_show_id = @tv_show.id
    if @episode.save
      render json: @episode
    else
      render json: @episode.errors.full_messages
    end
  end

  def update
    @tv_show = TvShow.find(params[:tv_show_id])
    @episode = Episode.where(id: params[:id], tv_show_id: @tv_show.id).first
    if @episode.update(episode_params)
      render json: @episode
    else
      render json: @episode.errors.full_messages
    end
  end

  def destroy
    @tv_show = TvShow.find(params[:tv_show_id])
    @episode = Episode.where(id: params[:id], tv_show_id: @tv_show.id).first
    @episode.delete
    render json: @episode
  end

  private
    def episode_params
      params.require(:episode).permit(:title, :watched, :episode)
    end

    def tv_show_exists?
      unless TvShow.where(id: params[:tv_show_id]).any?
        @error = {:error => "TvShow not found"}
        render json: @error
      end
    end
end
