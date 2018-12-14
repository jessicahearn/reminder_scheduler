FactoryBot.define do
  factory :reminder do
    user            { create(:user) }
    title           { "Reminder Title" }
    description     { "This is the body text of a reminder" }
    day_direction   { "from_beginning" }
    day_number      { 15 }
    timezone        { 'UTC' }
    send_time       { Time.now }
  end

  factory :reminder_variable_day, class: :reminder do
    user            { create(:user) }
    title           { "Reminder Title" }
    description     { "This is the body text of a reminder" }
    day_direction   { "from_beginning" }
    day_number      { 31 }
    timezone        { 'UTC' }
    send_time       { Time.now }
  end
end