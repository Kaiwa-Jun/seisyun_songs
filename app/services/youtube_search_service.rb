class YoutubeSearchService
  require 'net/http'
  require 'json'

  def initialize(keyword, page_token = nil)
    @keyword = keyword
    @page_token = page_token
    @api_key = ENV['YOUTUBE_API_KEY']
    Rails.logger.info("API key: #{@api_key}")
  end

  def search(page_token = nil)
  base_url = 'https://www.googleapis.com/youtube/v3/search'
  params = {
    key: @api_key,
    q: @keyword,
    type: 'video',
    maxResults: 20,
    part: 'snippet',
    pageToken: page_token # 次のページトークン
  }
  uri = URI(base_url)
  uri.query = URI.encode_www_form(params)

  # タイムアウト時間の設定
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.read_timeout = 10 # タイムアウト時間を10秒に設定

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

end
