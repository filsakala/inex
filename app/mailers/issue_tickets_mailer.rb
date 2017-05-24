class IssueTicketsMailer < ApplicationMailer

  def created_issue(issue_ticket, host)
    @issue_ticket_url = issue_ticket_url(id: issue_ticket.id, host: host)
    @issue_ticket = issue_ticket
    unless issue_ticket.image.blank?
      attachments["screenshot"] = { :mime_type => issue_ticket.image.content_type, :content => File.read(issue_ticket.image.path) }
    end
    mail(to: 'fil.sakala@gmail.com', subject: '[INEX] Nový issue ticket')
  end
end
