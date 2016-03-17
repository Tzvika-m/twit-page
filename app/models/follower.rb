class Follower < ActiveRecord::Base
  validates_uniqueness_of :user_id, :scope => :uid
end
