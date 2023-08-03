require 'rails_helper'

RSpec.describe User, type: :model do
  it "is invalid without a username" do
    user = User.new(username: nil, email: "test@test.com")
    expect(user).not_to be_valid
  end

  it "is invalid without an email" do
    user = User.new(username: "testuser", email: nil)
    expect(user).not_to be_valid
  end

  it "is invalid with a duplicate email" do
    User.create(username: "testuser1", email: "test@test.com")
    user = User.new(username: "testuser2", email: "test@test.com")
    expect(user).not_to be_valid
  end
end
