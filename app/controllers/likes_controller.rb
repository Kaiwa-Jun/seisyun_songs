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
      redirect_to songs_path, alert: "いいねに失敗しました。"
    end
  end

  def destroy
    like = current_user.likes.find_by(song_id: @song.id)
    like.destroy if like

    render turbo_stream: turbo_stream.replace(
      "like_button_#{@song.id}",
      partial: "likes/like_button",
      locals: { song: @song, liked: false }
    )
  end

  private

  def set_song
    @song = Song.find(params[:song_id])
  end
end
