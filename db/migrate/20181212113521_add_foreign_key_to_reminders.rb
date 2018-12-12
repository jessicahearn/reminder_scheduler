class AddForeignKeyToReminders < ActiveRecord::Migration[5.2]
  def change
    add_reference :reminders, :user, index: true
    add_foreign_key :reminders, :users, on_delete: :cascade
  end
end
