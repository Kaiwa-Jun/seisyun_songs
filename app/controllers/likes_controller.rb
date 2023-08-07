class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_song

def create
  like = current_user.likes.build(song_id: @song.id)
  if like.save
    render turbo_stream: turbo_stream.replace(
      "like_button_#{@song.id}",
      partial: "likes/like_button",
      locals: { song: @song, liked: true }
    )
  else
    # フラッシュメッセージを設定し、リダイレクトします。
    flash[:alert] = "いいねに失敗しました。"
    redirect_to some_path
  end
end

def destroy
  Rails.logger.info("Parameters: #{params.inspect}")
  like = current_user.likes.find_by(song_id: @song.id)
  if like&.destroy
    render turbo_stream: turbo_stream.replace(
      "like_button_#{@song.id}",
      partial: "likes/like_button",
      locals: { song: @song, liked: false }
    )
  else
    # フラッシュメッセージを設定し、リダイレクトします。
    flash[:alert] = "いいねの解除に失敗しました。"
    redirect_to some_path
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
