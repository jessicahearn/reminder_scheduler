class RemindersController < ApplicationController
  before_action :authenticate_user!
  def index
    @reminders = current_user.reminders.all
  end

  def new
  end

  def create
    reminder = Reminder.new(user: current_user, title: params[:reminder][:title], description: params[:reminder][:description])
    reminder.save!
  end

  def show
    @reminder = Reminder.where(id: params[:id]).first
  end
end