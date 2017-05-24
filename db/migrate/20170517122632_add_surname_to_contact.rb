class AddSurnameToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :surname, :string, limit: 128
  end
end
