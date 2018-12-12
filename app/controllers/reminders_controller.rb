class RemindersController < ApplicationController
  before_action :authenticate_user!
  def index
    @reminders = current_user.reminders.all
  end

  def new
  end

  def create
    reminder = Reminder.new(user: current_user, 
                            title: params[:reminder][:title], 
                            description: params[:reminder][:description])
    if reminder.save!
      flash[:notice] = "New reminder created!"
      redirect_to reminders_path
    else
      flash[:alert] = "Post cannot be saved. Please make sure you've included all necessary information."
    end
  end

  def show
    @reminder = Reminder.where(id: params[:id]).first
  end

  def destroy
    @reminder = Reminder.where(id: params[:id]).first
    @reminder.destroy

    flash[:notice] = "Reminder deleted"
    redirect_to reminders_path
  end
end