module ApplicationHelper
  def youtube_video_id(url)
    # URLから動画IDを取り出すロジック
    url.split('v=').last.split('&').first
  end
end
