class ReminderMailer < ApplicationMailer

  def confirmation_email(reminder)
    @reminder = reminder

    mail(to: reminder.user.email, subject: "New Reminder Created: " + reminder.title.to_s)
  end

  def reminder_email(reminder)
    @reminder = reminder

    mail(to: reminder.user.email, subject: reminder.title.to_s)
  end
end