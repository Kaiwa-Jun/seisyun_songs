class SongsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]

  def index
    @songs = Song.order(created_at: :desc).page(params[:page]).per(10)
  end

  def create
    @song = Song.new(song_params.merge(user_id: current_user.id))
    if @song.save
      redirect_to root_path, notice: "曲が正常に投稿されました!"
    else
      render :new
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.likes.destroy_all
    @song.destroy
    redirect_to root_path, status: :see_other, notice: "曲が正常に削除されました!"
  end

  # def search
  #   keyword = params[:keyword]
  #   @results = YoutubeSearchService.new(keyword).search

  #   render :new
  # end

  # def search
  #   keyword = params[:keyword]
  #   page_token = params[:page_token] # 次のページトークン
  #   results = YoutubeSearchService.new(keyword).search
  #   @results = Kaminari.paginate_array(results).page(params[:page]).per(10)

  #   # 次のページトークンをビューで使用できるようにします
  #   @next_page_token = next_page_token

  #   render :new
  # end

  def search
  keyword = params[:keyword]
  page_token = params[:page_token]
  @results, @next_page_token = YoutubeSearchService.new(keyword, page_token).search

  render :new
end





  private

  def authenticate_user!
    unless current_user
      redirect_to login_path, alert: "ログインしてください"
    end
  end

  def song_params
    params.require(:song).permit(:title, :artist, :youtube_url, :user_id)
  end
end
