class AddUnfollowDateToFollowers < ActiveRecord::Migration
  def change
  	add_column :followers, :unfollow_date, :datetime
  	
  end
end
