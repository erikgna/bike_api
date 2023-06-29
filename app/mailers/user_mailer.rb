class UserMailer < ApplicationMailer
    def confirmation_email(user)
        mail(to: user.email, subject: 'Confirmação de cadastro')
    end
end
