class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_song

def create
  @song = Song.find(params[:song_id])
  @like = current_user.likes.build(song_id: @song.id)

  respond_to do |format|
    if @like.save
      format.turbo_stream { render turbo_stream: turbo_stream.replace("like-wrapper-#{@song.id}", partial: 'likes/like_button', locals: { song: @song, liked: true }) }
      format.html { redirect_to songs_path }
    else
      flash[:alert] = "いいねに失敗しました。"
      format.html { redirect_to songs_path }
    end
  end
end


def destroy
  @song = Song.find(params[:song_id])
  like = current_user.likes.find_by(song_id: @song.id)

  respond_to do |format|
    if like&.destroy
      format.turbo_stream { render turbo_stream: turbo_stream.replace("like-wrapper-#{@song.id}", partial: 'likes/like_button', locals: { song: @song, liked: false }) }
      format.html { redirect_to songs_path }
    else
      flash[:alert] = "いいねの解除に失敗しました。"
      format.html { redirect_to songs_path }
    end
  end
end


  private

  def set_song
    Rails.logger.info("params[:song_id]: #{params[:song_id]}")
    @song = Song.find_by(id: params[:id] || params[:song_id])
    unless @song
      flash[:alert] = "曲が見つかりませんでした。"
      redirect_to songs_path
    end
  end
end
