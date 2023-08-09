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

# scope :top_likes_by_age, ->(age_range) do
#   select('songs.title, SUM(likes.id) AS total_likes')
#     .joins(likes: :user)
#     .where(users: { age: age_range })
#     .group('songs.title')
#     .order('total_likes DESC')
#     .limit(5)
# end
def self.top_likes_by_age(age_range)
  # 投稿ユーザーの年齢を基に、その年齢層の投稿に対するいいね数を集計します
  joins(:user, :likes)
    .where(users: { age: age_range })
    .group('songs.title')
    .select('songs.title, COUNT(likes.id) AS likes_count')
    .order('likes_count DESC')
    .limit(5)
end


end
