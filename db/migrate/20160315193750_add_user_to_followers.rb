class AddUserToFollowers < ActiveRecord::Migration
  def change
    add_reference :followers, :user, foreign_key: true
  end
end
