require 'rails_helper'

RSpec.describe Like, type: :model do
  it "is invalid without a user" do
    like = Like.new(user: nil, song: Song.new)
    expect(like).not_to be_valid
  end

  it "is invalid without a song" do
    like = Like.new(user: User.new, song: nil)
    expect(like).not_to be_valid
  end
end
