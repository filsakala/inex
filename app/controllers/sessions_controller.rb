class SessionsController < ApplicationController
  layout 'page_part'

  def new
  end

  def create
    user = User.find_by_login_mail(params[:login_mail])
    if user && user.authenticate_active(params[:password])
      session[:user_id] = user.id
      if user.is_inex_office?
        redirect_to tasks_path, success: t(:you_were_successfully_logged_in)
      else
        redirect_to user, success: t(:you_were_successfully_logged_in)
      end
    else
      flash.now.alert = if !user.try(:is_active?)
                          t(:user_is_inactive)
                        else
                          t(:login_was_unsuccessfull)
                        end
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_path, success: t(:you_were_successfully_logged_out)
  end

  def forgotten_password
    if !params[:commit].blank?
      if !params[:login_mail].blank?
        @user = User.find_by_login_mail(params[:login_mail])
        if @user # reset!
          @user.password = @user.password_confirmation = SecureRandom.urlsafe_base64
          @user.save(validate: false)
          UserMailer.reset_password_mail(@user, "#{request.protocol}#{request.host_with_port}", @user.password).deliver_now
          redirect_to new_session_path, success: t(:password_was_changed_and_sent_by_email)
        else
          redirect_to :back, error: t(:user_with_given_email_does_not_exist)
        end
      else
        redirect_to :back, error: t(:we_need_your_login_mail_for_resetting_password)
      end
    end
  end
end
