class Permission < ActiveRecord::Base
=begin
Predpoklady:
1. Employee moze vsetko (netreba definovat).
2. Kazda skorsia rola moze vsetko co ta potom (employee > eds > user > nologin) + nieco navyse.
3. Ostatne role: Musi byt definovane danej roli alebo rolam pod nou. Inak sa berie, ze to nemoze.
=end

  def self.user_role(user)
    if user
      if user.is_employee?
        "employee"
      elsif user.is_evs?
        "eds"
      else
        "user"
      end
    else
      "nologin"
    end
  end

  # "Is subrole subrole of role of_role?"
  def self.is_subrole?(subrole, of_role)
    case subrole
      when "nologin"
        true
      when "user"
        if of_role == "nologin"
          false
        else
          true
        end
      when "eds"
        if of_role == "nologin" || of_role == "user"
          false
        else
          true
        end
      else
        false
    end
  end

  def self.can?(controller, action, user)
    return true if controller == "homepage" && action == "web" # root adresa nech je pristupna
    role = self.user_role(user)
    return true if role == "employee" # Predpoklad 1
    cperm = Permission.where(controller: controller).where(action: action)
    return false if !cperm.any? # Predpoklad 3
    cperm.each do |perm|
      return true if is_subrole?(perm.role, role) # Predpoklad 2
    end
    return false
  end

end
