class UserMailerWorker
    include Sidekiq::Worker
  
    def perform(user_id)
      user = User.find(user_id)
      UserMailer.confirmation_email(user).deliver_now
    end
  end
  