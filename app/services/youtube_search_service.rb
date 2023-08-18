require 'net/http'
require 'json'
require 'httparty'

class YoutubeSearchService

  def initialize(keyword, selected_year, page_token = nil)
    @keyword = keyword
    @selected_year = selected_year
    @page_token = page_token
    @api_key = ENV['YOUTUBE_API_KEY']
  end

def search(page_token = nil)
  # 検索クエリの設定
  query_parts = []
  query_parts << @selected_year if @selected_year.present? # 年があれば追加
  query_parts << "J-Pop"
  query_parts << @keyword if @keyword.present? # キーワードがあれば追加
  query = query_parts.join(" ")

  # 検索パラメータの設定
  params = {
    key: @api_key,
    q: query,
    type: 'video',
    maxResults: 50,
    part: 'snippet'
  }
  Rails.logger.info("Search params: #{params.inspect}") # ここでパラメータのログを出力

  # 検索リクエストの実行
  uri = URI('https://www.googleapis.com/youtube/v3/search')
  uri.query = URI.encode_www_form(params)
  response = HTTParty.get(uri)
  json = JSON.parse(response.body)

  # YouTube APIからの応答の確認
  Rails.logger.info("YouTube API response: #{json['items'].take(3).inspect}") # ここでレスポンスのログを出力


  # 投稿年でフィルタリング
  filtered_results = if @selected_year.blank?
    json['items']
  else
    json['items'].select do |item|
      published_at = item['snippet']['publishedAt']
      published_year = Date.parse(published_at).year
      published_year == @selected_year.to_i
    end
  end

  # 視聴回数でソート
  sorted_results = filtered_results.sort_by do |item|
    video_id = item['id']['videoId']
    video_details = get_video_details(video_id)
    -video_details['statistics']['viewCount'].to_i
  end

  # 結果のマッピング
  results = sorted_results.map do |video|
    title = video['snippet']['title']
    next if title.include?("メドレー") # メドレーを含むタイトルは除外
    {
      title: title,
      youtube_url: "https://www.youtube.com/watch?v=#{video['id']['videoId']}"
    }
  end.compact # nilを除外

  Rails.logger.info("Results: #{results.inspect}")
  return results # resultsを返す
end



  private

def get_video_details(video_id)
  params = {
    key: @api_key,
    id: video_id,
    part: 'statistics'
  }
  uri = URI('https://www.googleapis.com/youtube/v3/videos')
  uri.query = URI.encode_www_form(params)
  response = HTTParty.get(uri)
  JSON.parse(response.body)['items'].first
end

  def search_playlist
    query = "#{@selected_year} J-Pop ヒット曲 プレイリスト"
    encoded_query = CGI.escape(query)
    url = "https://www.googleapis.com/youtube/v3/search?key=#{@api_key}&q=#{encoded_query}&type=playlist&maxResults=1&part=snippet"
    response = HTTParty.get(url)
    playlist_id = response['items'].first['id']['playlistId'] if response['items'].any?
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
