class Song < ApplicationRecord
  belongs_to :user
  has_many :likes

  validates :title, presence: true
  validates :artist, presence: true
  validates :user_id, presence: true
  validates :youtube_url, presence: true

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  def self.top_likes_by_age(age_range)
    joins(:user, :likes)
      .where(users: { age: age_range })
      .group('songs.title, songs.youtube_url')
      .select('songs.title, songs.youtube_url, COUNT(likes.id) AS likes_count')
      .order('likes_count DESC')
      .limit(5)
  end
end
