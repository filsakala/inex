module ContactListsHelper

  def prepare_mails_for_copy(users)
    result = []
    users.each do |user|
      unless user.personal_mail.blank?
        result << user.personal_mail
      else
        result << user.login_mail
      end
    end
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
