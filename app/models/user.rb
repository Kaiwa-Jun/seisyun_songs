class User < ApplicationRecord
  has_many :songs
  has_many :likes

  validates :username, presence: true
  validates :email, presence: true, uniqueness: true
  validates :age, presence: true
  has_secure_password
end