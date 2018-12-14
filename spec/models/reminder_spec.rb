require 'rails_helper'
require 'spec_helper'

RSpec.describe Reminder, type: :model do

  before(:each) do
    Sidekiq::ScheduledSet.new.clear
    ActionMailer::Base.deliveries = []
  end

  it "should create a new reminder given valid attributes" do
    Reminder.create!(attributes_for(:reminder))
    expect(Reminder.count).to eq(1)
  end

  it "should not create a new reminder if title is not provided" do
    Reminder.create(attributes_for(:reminder, title: ""))
    expect(Reminder.count).to eq(0)
  end

  it "should not create a new reminder if description is not provided" do
    Reminder.create(attributes_for(:reminder, description: ""))
    expect(Reminder.count).to eq(0)
  end

  it "should not create a new reminder if day_direction is not provided" do
    Reminder.create(attributes_for(:reminder, day_direction: ""))
    expect(Reminder.count).to eq(0)
  end

  it "should not create a new reminder if invalid day_direction is provided" do
    Reminder.create(attributes_for(:reminder, day_direction: "invalid_day_direction"))
    expect(Reminder.count).to eq(0)
  end

  it "should not create a new reminder if day_number is not provided" do
    Reminder.create(attributes_for(:reminder, day_number: nil))
    expect(Reminder.count).to eq(0)
  end

  it "should not create a new reminder if timezone is not provided" do
    Reminder.create(attributes_for(:reminder, timezone: ""))
    expect(Reminder.count).to eq(0)
  end

  it "should not create a new reminder if invalid timezone is provided" do
    Reminder.create(attributes_for(:reminder, timezone: "invalid_time_zone"))
    expect(Reminder.count).to eq(0)
  end

  it "should not create a new reminder if send_time is not provided" do
    Reminder.create(attributes_for(:reminder, send_time: nil))
    expect(Reminder.count).to eq(0)
  end

  it "should schedule the next reminder email when a valid reminder is created" do
    expect(Sidekiq::ScheduledSet.new.size).to eq(0)
    Reminder.create!(attributes_for(:reminder))
    expect(Reminder.count).to eq(1)
    expect(Sidekiq::ScheduledSet.new.size).to eq(1)
  end

  it "should delete a reminder when the user it belongs to is deleted" do
    user = create(:user)
    reminder = create(:reminder, user: user)
    expect(User.count).to eq(1)
    expect(Reminder.count).to eq(1)
    user.destroy
    expect(User.count).to eq(0)
    expect(Reminder.count).to eq(0)
  end

  it "should send a reminder setup confirmation email when a new reminder is created" do
    expect(ActionMailer::Base.deliveries.count).to eq(0)
    Reminder.create!(attributes_for(:reminder))
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  it "should schedule a reminder set for a nonexistent day on the closest available day" do
    reminder = create(:reminder_variable_day)
    january_send_date = reminder.calculate_send_date_for(2019, 1)
    expect(january_send_date.day).to eq(31)
    april_send_date = reminder.calculate_send_date_for(2019, 4)
    expect(april_send_date.day).to eq(30)
  end
end