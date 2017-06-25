module ContactListsHelper

  def personal_mail_or_login_mail(user)
    unless user.personal_mail.blank?
      user.personal_mail
    else
      user.login_mail
    end
  end

  def prepare_mails_for_copy(users)
    result = users.collect { |user| personal_mail_or_login_mail(user) }
    if result.blank?
      t(:empty)
    else
      result.join(', ')
    end
  end

  def active_class(controllers = [], actions = [], id = nil)
    if controllers.blank?
      if !actions.blank?
        if !id.blank?
          return "active" if params[:id] == id && actions.include?(action_name)
        else
          return "active" if actions.include?(action_name)
        end
      end
    else
      if current_controller?(controllers)
        if !actions.blank?
          if !id.blank?
            return "active" if params[:id].to_i == id && actions.include?(action_name)
          else
            return "active" if actions.include?(action_name)
          end
        else
          return "active"
        end
      end
    end
    return ""
  end
end
