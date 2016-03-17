class AddIsDismissedToFollowersAgain < ActiveRecord::Migration
  def change
  	add_column :followers, :is_dismissed, :boolean, :default => false
  end
end
