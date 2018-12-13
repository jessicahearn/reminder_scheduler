class RemindersController < ApplicationController
  before_action :authenticate_user!
  def index
    @reminders = current_user.reminders.all
  end

  def new
  end

  def create
    reminder = Reminder.new(user: current_user, 
                            title: reminder_params[:title], 
                            description: reminder_params[:description],
                            day_direction: reminder_params[:day_direction],
                            day_number: reminder_params[:day_number],
                            timezone: reminder_params[:timezone],
                            send_time: parsed_send_time)
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


  private

  def reminder_params
    params.require(:reminder).permit(:title, 
                                     :description, 
                                     :day_direction, 
                                     :day_number, 
                                     :timezone, 
                                     :hour, 
                                     :minute)
  end

  def parsed_send_time
    assembled_time = reminder_params[:hour].to_s + ":" + reminder_params[:minute].to_s
    parsed_time = ActiveSupport::TimeZone.new(reminder_params[:timezone])
                                              .parse(assembled_time)
    return parsed_time
  end
end