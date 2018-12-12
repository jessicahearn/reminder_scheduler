class AddSendDatetimeToReminders < ActiveRecord::Migration[5.2]
  def change
    add_column :reminders, :day_direction, :string
    add_column :reminders, :day_count, :integer
    add_column :reminders, :timezone, :string
  end
end
