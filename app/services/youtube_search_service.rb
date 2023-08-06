class YoutubeSearchService
  require 'net/http'
  require 'json'

  def initialize(keyword)
    @keyword = keyword
    @api_key = ENV['YOUTUBE_API_KEY']
  end

  def search
    base_url = 'https://www.googleapis.com/youtube/v3/search'
    params = {
      key: @api_key,
      q: @keyword,
      type: 'video',
      maxResults: 10, # 10件の検索結果を取得
      part: 'snippet'
    }
    uri = URI(base_url)
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)
    json = JSON.parse(response.body)
    json['items'].map do |item|
      {
        title: item['snippet']['title'],
        artist: item['snippet']['channelTitle'],
        youtube_url: "https://www.youtube.com/watch?v=#{item['id']['videoId']}"
      }
    end
  end
end
