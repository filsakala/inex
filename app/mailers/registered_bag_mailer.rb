class RegisteredBagMailer < ApplicationMailer

  def registered_bag(mail, event_list, host)
    @event_list_url = event_list_url(id: event_list.id, host: host)
    # Generate PDF
    template = File.read(Rails.root.join("app", "views", "event_lists", "employee_show.pdf.prawn"))
    pdf = Prawn::Document.new(:page_size => 'A4')
    pdf.instance_eval do
      @event_list = event_list
      eval(template) #this evaluates the template with your variables
    end
    #
    attachment = pdf.render
    attachments['prihlaska.pdf'] = { :mime_type => 'application/pdf', :content => attachment }
    mail(to: mail, subject: 'Tvoja taška eventov bola registrovaná')
  end

  def registered_bag_employee(employee_mail, event_list, host)
    @pdf_url = employee_show_event_list_url(id: event_list.id, host: host) + ".pdf"
    @event_list_url = employee_show_event_list_url(id: event_list.id, host: host)
    mail(to: employee_mail, subject: '[INEX] Registrácia tašky eventov')
  end

  def added_payment_mail(employee, payment, host)
    @payment = payment
    @user = @payment.user
    @user_url = user_url(id: @user.id, host: host)
    @payment_url = participation_fee_url(id: @payment.id, host: host)
    if !@payment.event_list.blank?
      @event_type = @payment.event_list.event_type
      @event_list_url = employee_show_event_list_url(id: @payment.event_list_id, host: host)
    end
    mail = ""
    if employee.work_mail.blank?
      mail = employee.try(:user).try(:login_mail)
    else
      mail = employee.work_mail
    end
    mail(to: mail, subject: '[INEX] Bola pridaná platba') unless mail.blank?
  end
end
