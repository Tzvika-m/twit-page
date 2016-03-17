class HomeController < ApplicationController
  
  def index
    if session[:user_id]
      @new_followers = Follower.where(user_id: session[:user_id], is_new: true, is_dismissed: false).where("unfollow_date IS NULL").order(created_at: :desc).limit(3)
      @new_unfollowers = Follower.where(user_id: session[:user_id], is_dismissed: false).where("unfollow_date > ?", 1.week.ago).order(unfollow_date: :desc)
    end
  end

  def create_session
    @user = User.find_or_create_by_auth(auth_hash)

    twitter_api = Twitter::TwitterApi.new(@user)
    twitter_api.update_followers

    session[:user_id] = @user.id
    redirect_to root_path
  end

  def sign_out
    session[:user_id] = nil
    redirect_to root_path
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end