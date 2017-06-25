module UsersHelper
   include ActionView::Helpers::UrlHelper

  def mail_links(binding)
		file = File.open(Rails.root.join("app", "views", "users", "datatable_columns", "mail_links.html.erb")).read
    ERB.new(file).result(binding)
  end

  def user_states(binding)
		file = File.open(Rails.root.join("app", "views", "users", "datatable_columns", "user_states.html.erb")).read
    ERB.new(file).result(binding)
  end

  def user_actions(binding)
		file = File.open(Rails.root.join("app", "views", "users", "datatable_columns", "user_actions.html.erb")).read
		ERB.new(file).result(binding)
  end
end
