class UserMailer < ApplicationMailer
    def confirmation_email(user)
        confirmation_url = "#{ENV['BASE_URL']}/users/confirm_email/#{user.token}"
        puts "URL gerada: #{confirmation_url}"
        # mail(to: user.email, subject: 'Confirmação de cadastro')
    end
end
