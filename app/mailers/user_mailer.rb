class UserMailer < ApplicationMailer

  def welcome_email(user, host)
    @user = user
    @url = new_session_url(host: host)
    mail(to: user.login_mail, subject: 'Registrácia na inex.sk')
  end

  def reset_password_mail(user, host, password)
    @user = user
    @url = new_session_url(host: host)
    @password = password
    mail(to: user.login_mail, subject: 'Reset hesla na inex.sk')
  end

  def send_question_mail(mail, text)
    @text = text
    mail(to: mail, subject: '[INEX] Niekto ti poslal otázku zo stránky.')
  end
end
