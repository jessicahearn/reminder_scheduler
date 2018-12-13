class Reminder < ApplicationRecord
  include ActiveSupport

  attr_accessor :hour, :minute

  validates :title, presence: true
  validates :description, presence: true
  validates :day_direction, presence: true
  validates :day_number, presence: true
  validates :timezone, presence: true
  validates :send_time, presence: true

  belongs_to :user

  after_create :send_confirmation_email
  after_create :schedule_reminders

  module DayDirections
    FROM_BEGINNING = "from_beginning"
    FROM_END = "from_end"
  end

  validates_inclusion_of :day_direction, in: :allowed_directions

  validates_inclusion_of :timezone, in: :allowed_timezones

  def allowed_directions
    DayDirections.constants(false).map{ |c| DayDirections.const_get(c) }
  end

  def allowed_timezones
    timezones = TimeZone.all.map(&:name)
    return timezones
  end

  def day_direction_display
    if day_direction == DayDirections::FROM_END
      return "end"
    else
      return "beginning"
    end
  end

  def timezone_display
    Time.now.in_time_zone(ActiveSupport::TimeZone[timezone]).strftime('%Z')
  end

  def calculate_send_date_for(year, month)
    # This method expects arguments in integers (e.g. (2012, 8))

    scheduled_date = send_time.change(year: year, month: month, day: relative_sending_day(year, month))
  end

  def upcoming_send_dates(months)
    # This method expects an integer representing the number of
    # upcoming months to calculate.

    today = Time.now
    date_collection = []
    this_month = calculate_send_date_for(today.year, today.month)
    if this_month.past?
      (1..months).each do |n|
        date_collection << this_month.advance(months: n)
      end
    else
      (0..months-1).each do |n|
        date_collection << this_month.advance(months: n)
      end
    end

    return date_collection
  end

  def next_occurrence
    upcoming_send_dates(1).first
  end

  def send_confirmation_email
    ReminderMailer.confirmation_email(self).deliver_now
  end

  def schedule_reminders
    ReminderWorker.perform_at(next_occurrence, id)
  end


  private

  def absolute_sending_day
    calculated_day = day_number

    if day_direction == DayDirections::FROM_END
      calculated_day = 31 - (day_number - 1)
    end

    return calculated_day
  end

  def relative_sending_day(year, month)
    # This method expects arguments in integers (e.g. (2012, 8))

    calculated_day = absolute_sending_day
    target_month = Time.new(year, month, 1, 0,0,0)

    if absolute_sending_day > target_month.end_of_month.day
      calculated_day = target_month.end_of_month.day
    end

    return calculated_day
  end
end




