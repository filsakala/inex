class IssueTicketIncreaseLimit < ActiveRecord::Migration
  # def change
  # end

  def up
    change_column :issue_tickets, :description, :text, :limit => 4096
  end

  def down
    change_column :issue_tickets, :description, :string
  end
end
