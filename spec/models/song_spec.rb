require 'rails_helper'

RSpec.describe Song, type: :model do
  it "is invalid without a title" do
    song = Song.new(title: nil, artist: "artist", youtube_url: "https://youtube.com", user: User.new)
    expect(song).not_to be_valid
  end

  it "is invalid without an artist" do
    song = Song.new(title: "title", artist: nil, youtube_url: "https://youtube.com", user: User.new)
    expect(song).not_to be_valid
  end

  it "is invalid without a youtube_url" do
    song = Song.new(title: "title", artist: "artist", youtube_url: nil, user: User.new)
    expect(song).not_to be_valid
  end

  it "is invalid without a user" do
    song = Song.new(title: "title", artist: "artist", youtube_url: "https://youtube.com", user: nil)
    expect(song).not_to be_valid
  end
end
