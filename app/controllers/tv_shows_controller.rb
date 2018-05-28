class TvShowsController < ApplicationController
  before_action :authenticate_user!
  before_action :tv_show_exists?, only: [:show, :update, :destroy]

  def index
    @tv_shows = TvShow.all
    render json: @tv_shows
  end

  def show
    if TvShow.where(id: params[:id]).any?
      @tv_show = TvShow.find(params[:id])
      render json: @tv_show
    else
      @error = {:error => "TvShow not found"}
      render json: @error
    end
  end

  def create
    @tv_show = TvShow.new(tv_show_params)
    @tv_show.user_id = current_user.id
    if @tv_show.save
      render json: @tv_show
    else
      @error = {:error => "TvShow cannot be created"}
      render json: @error
    end
  end

  def update
    @tv_show = TvShow.find(params[:id])
    if @tv_show.update(tv_show_params)
      render json: @tv_show
    else
      @error = {:error => "TvShow cannot be updated"}
      render json: @error
    end
  end

  def destroy
    @tv_show = TvShow.find(params[:id])
    @tv_show.delete
    render json: @tv_show
  end

  private
    def tv_show_params
      params.require(:tv_show).permit(:title, :description)
    end

    def tv_show_exists?
      unless TvShow.where(id: params[:id]).any?
        @error = {:error => "TvShow not found"}
        render json: @error
      end
    end
end
