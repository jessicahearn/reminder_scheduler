# Reminder Scheduler

## Introduction

This is a simple prototype of a reminder scheduling application. The application performs the following functions:

* Allows users to sign up, sign in, and change their password if forgotten.

* Allows users to create and schedule monthly reminders to be emailed to them on a specified day and time. (Note that if a given day does not exist in a particular month -- e.g. the 31st of February -- the reminder will be sent on the closest available day within the same month.)

* Allows users to delete existing reminders.


## Environment Setup

### Dependencies

* Ruby Version: 2.5.3
* PostgrSQL
* Redis

### Local Setup

* `bundle install`
* `bundle exec rake db:create:all`
* `bundle exec rake db:migrate`
* `rails s`

### To Test Email/Scheduling Functionality

* `redis-server`
* `bundle exec sidekiq`


## Future Recommended Features

* Allow users to edit and reschedule existing reminders.

* Allow users to pause or deactivate reminders without deleting them.

* As the application scales, it would be recommended to implement a more robust scheduler to ensure that jobs would not be lost in the event of server errors or other disruptions. (For instance, it might be wise to explicitly state which reminders are active, track the history of when reminders have been sent so that any missed reminders due to intermittent errors can be re-sent, and run a daily or hourly cronjob to queue up messages so that they would not have to be scheduled in sidekiq a month in advance.)


