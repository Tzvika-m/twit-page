class FollowerController < ApplicationController
  def dismiss
    result = dismissFollower({uid: params[:uid]})

    if !result
      render nothing: true, status: 400
    else
      return_data = getList(params[:list])
      render json: return_data, status: 200
    end
  end

  def follow
    twitter_api = Twitter::TwitterApi.new(current_user)
    # Follow the member on twitter
    result = twitter_api.follow(params[:uid])

    if !result
      render nothing: true, status: 400
    else
      # Dismiss the member
      dismissFollower({uid: params[:uid]})
      return_data = getList(params[:list])
      render json: return_data, status: 200
    end
  end

  def sayhi
    twitter_api = Twitter::TwitterApi.new(current_user)
    # Post a new twit
    result = twitter_api.sayhi(params[:handle])

    if !result
      render nothing: true, status: 400
    else
      # Dismiss the member
      dismissFollower({handle: params[:handle]})
      return_data = getList(params[:list])
      render json: return_data, status: 200
    end
  end

  private
  # Get the top 3 members to present in the page, whether it's the followers or unfollowers list
  def getList(list_type)
    if list_type == 'followers'
      return_data = Follower.where(user_id: session[:user_id], is_new: true, is_dismissed: false).where("unfollow_date IS NULL").order(created_at: :desc).limit(3)
    elsif list_type == 'unfollowers'
      return_data = Follower.where(user_id: session[:user_id], is_dismissed: false).where("unfollow_date > ?", 1.week.ago).order(unfollow_date: :desc)
    end

    return_data
  end

  # Dismiss a member according to the condition that was sent (could be uid or handle)
  def dismissFollower(condition)
    follower = Follower.where(condition).where(user_id: session[:user_id]).take
    if follower
      result = follower.update(is_dismissed: true)
    end
    if !follower || !result
      nil
    else
      result
    end
  end

end