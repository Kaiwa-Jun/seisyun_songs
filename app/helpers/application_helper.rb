module ApplicationHelper
  def youtube_video_id(url)
    # URLから動画IDを取り出すロジック
    url.split('v=').last.split('&').first
  end

  def tailwind_alert_class(message_type)
    base_class = "alert-message " # alert-message クラスを追加

    case message_type.to_sym
    when :success
      base_class + "bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded"
    when :error
      base_class + "bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded"
    when :warning
      base_class + "bg-yellow-100 border border-yellow-500 text-yellow-700 p-4 rounded"
    else
      base_class + "bg-blue-100 border border-blue-500 text-blue-700 px-4 py-3 rounded"
    end
  end
end
