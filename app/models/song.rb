class Song < ApplicationRecord
  belongs_to :user
  has_many :likes

  validates :title, presence: true
  validates :artist, presence: true
  validates :user_id, presence: true
  validates :youtube_url, presence: true
end
