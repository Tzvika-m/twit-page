class AddIsNewToFollowers < ActiveRecord::Migration
  def change
  	add_column :followers, :is_new, :boolean
  end
end
