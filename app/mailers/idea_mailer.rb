# coding: utf-8
class IdeaMailer < ActionMailer::Base
  default from: "Mangueza de Ideias <manguezaldeideias@gmail.com>"

  def notification_email(audit, user)
    @audit = audit
    @user = user
    @notification_text = audit.notification_text(user)
    
    return unless @notification_text and @user.email
    
    @notification_text.gsub!("href='/", "href='http://manguezaldeideias.herokuapp.com/")
    
    mail(to: "#{@user.name} <#{@user.email}>", subject: (@audit.notification_subject or "Tem novidade para você no Manguezal de Ideias :D")) do |format|
      format.html
    end

  end

end