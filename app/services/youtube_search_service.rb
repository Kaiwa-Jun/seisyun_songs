require 'net/http'
require 'json'
require 'httparty'

class YoutubeSearchService

  def initialize(keyword, selected_year)
    @keyword = keyword
    @selected_year = selected_year
    @api_key = ENV['YOUTUBE_API_KEY']
  end

  def search(page_token = nil)
  base_url = 'https://www.googleapis.com/youtube/v3/search'
  query = "#{@keyword} #{@selected_year} "
  playlist_id = search_playlist
    # プレイリスト内の動画を取得
  videos = get_playlist_videos(playlist_id)
  params = {
    key: @api_key,
    q: query,
    type: 'video',
    maxResults: 20,
    part: 'snippet',
    pageToken: page_token
  }
  uri = URI(base_url)
  uri.query = URI.encode_www_form(params)

  # タイムアウト時間の設定
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.read_timeout = 10

  response = http.request(Net::HTTP::Get.new(uri.request_uri))
  json = JSON.parse(response.body)
  Rails.logger.info("YouTube API response: #{json.inspect}")
  # 応答のエラーチェック
  if json['items'].nil?
    Rails.logger.error("YouTube API response error: #{response.body}")
    return [Kaminari.paginate_array([]).page(params[:page]).per(20), nil]
  end

  results = json['items'].map do |item|
    {
      title: item['snippet']['title'],
      artist: item['snippet']['channelTitle'],
      youtube_url: "https://www.youtube.com/watch?v=#{item['id']['videoId']}"
    }
  end
  next_page_token = json['nextPageToken']
  [Kaminari.paginate_array(results).page(params[:page]).per(20), next_page_token]
end

  private

  def search_playlist
    query = "#{@selected_year} J-Pop ヒット曲 プレイリスト"
    url = "https://www.googleapis.com/youtube/v3/search?key=#{@api_key}&q=#{query}&type=playlist&maxResults=1&part=snippet"
    response = HTTParty.get(url)
    playlist_id = response['items'].first['id']['playlistId']
    playlist_id
  end

  def get_playlist_videos(playlist_id)
    url = "https://www.googleapis.com/youtube/v3/playlistItems?key=#{@api_key}&playlistId=#{playlist_id}&maxResults=20&part=snippet"
    response = HTTParty.get(url)
    videos = response['items'].map do |item|
      {
        title: item['snippet']['title'],
        video_id: item['snippet']['resourceId']['videoId'],
        # 他の属性
      }
    end
    videos
  end

end
