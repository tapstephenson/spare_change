class SidetiqWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { weekly.day(:friday) }

  def perform
    UserMailer.delay.weekly_email(current_user.id)
  end
end