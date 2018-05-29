class TvShowsController < ApplicationController
  before_action :authenticate!
  before_action :current_user_owner?, only: [:update, :destroy]
  before_action :tv_show_exists?, only: :show

  def index
    @tv_shows = TvShow.all
    render json: @tv_shows
  end

  def show
      @tv_show = TvShow.find(params[:id])
      render json: @tv_show
  end

  def create
    @tv_show = TvShow.new(tv_show_params)
    @tv_show.user_id = current_user.id
    if @tv_show.save
      render json: @tv_show
    else
      render json: {:error => @tv_show.errors.full_messages}
    end
  end

  def update
    @tv_show = TvShow.find(params[:id])
    if @tv_show.update(tv_show_params)
      render json: @tv_show
    else
      render json: {:error => @tv_show.errors.full_messages}
    end
  end

  def destroy
    @tv_show = TvShow.find(params[:id])
    @tv_show.delete
    render json: @tv_show
  end

  private
    def tv_show_params
      params.require(:tv_show).permit(:title, :description, :rank)
    end

    def tv_show_exists?
      unless TvShow.where(id: params[:id]).any?
        @error = {:error => "TvShow not found"}
        render json: @error
      else
        false
      end
    end

    def current_user_owner?
      unless tv_show_exists?
        if current_user != TvShow.find(params[:id]).user
          @error = {:error => "You don't have permission to edit this TvShow"}
          render json: @error
        end
      end
    end
end
