class YoutubeSearchService
  require 'net/http'
  require 'json'

  # def initialize(keyword)
  #   @keyword = keyword
  #   @api_key = ENV['YOUTUBE_API_KEY']
  # end

  def initialize(keyword, page_token = nil)
    @keyword = keyword
    @page_token = page_token
    @api_key = ENV['YOUTUBE_API_KEY']
  end


  def search(page_token = nil)
    base_url = 'https://www.googleapis.com/youtube/v3/search'
    params = {
      key: @api_key,
      q: @keyword,
      type: 'video',
      maxResults: 20, # 10件の検索結果を取得
      part: 'snippet',
      pageToken: page_token # 次のページトークン
    }
    uri = URI(base_url)
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)
    json = JSON.parse(response.body)
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
