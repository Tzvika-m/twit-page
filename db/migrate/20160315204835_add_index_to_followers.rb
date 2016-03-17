class AddIndexToFollowers < ActiveRecord::Migration
  def change
  	add_index :followers, :user_id
  end
end
