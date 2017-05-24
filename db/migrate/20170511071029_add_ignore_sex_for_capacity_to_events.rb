class AddIgnoreSexForCapacityToEvents < ActiveRecord::Migration
  def change
    add_column :events, :ignore_sex_for_capacity, :boolean
  end
end
