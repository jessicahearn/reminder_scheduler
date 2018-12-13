class ReminderWorker
  include Sidekiq::Worker

  def perform(reminder_id)
    reminder = Reminder.find(reminder_id)

    unless reminder.blank?
      # If the reminder has been deleted since the last occurrence,
      # the job will fail silently and will not be rescheduled.

      ReminderMailer.reminder_email(reminder).deliver_now

      ReminderWorker.perform_at(reminder.next_occurrence, reminder_id)
    end
  end
end