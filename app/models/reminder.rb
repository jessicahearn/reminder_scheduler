class Reminder < ApplicationRecord
  include ActiveSupport

  attr_accessor :hour
  attr_accessor :minute

  validates :title, presence: true
  validates :description, presence: true

  belongs_to :user

  module DayDirections
    FROM_BEGINNING = "from_beginning"
    FROM_END = "from_end"
  end

  allowed_directions = DayDirections.constants(false).map{ |c| DayDirections.const_get(c) }
  validates_inclusion_of :day_direction, in: allowed_directions

  validates_inclusion_of :timezone, in: :allowed_timezones

  def self.allowed_timezones
    timezones = TimeZone.all.map(&:name)
    return timezones
  end

end