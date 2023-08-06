class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    like = current_user.likes.build(song_id: params[:song_id])
    if like.save
      redirect_to songs_path, notice: "曲をいいねしました！"
    else
      redirect_to songs_path, alert: "いいねに失敗しました。"
    end
  end
end
