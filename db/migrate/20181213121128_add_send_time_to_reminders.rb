class AddSendTimeToReminders < ActiveRecord::Migration[5.2]
  def change
    add_column :reminders, :send_time, :time
  end
end
