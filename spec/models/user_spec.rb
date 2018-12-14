require 'rails_helper'
require 'spec_helper'

RSpec.describe User, type: :model do

  it "should create a new user given valid email and password" do
    User.create!(attributes_for(:user))
    expect(User.count).to eq(1)
  end

  it "should not create a new user given an invalid email address" do
    User.create(email: "00000000", password: "password", password_confirmation: "password")
    expect(User.count).to eq(0)
  end
end
