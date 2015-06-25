class SidetiqWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { weekly.day(:thursday).hour_of_day(19).minute_of_hour(10) }

  def perform
    UserMailer.delay.weekly_email(current_user.id)
  end
end