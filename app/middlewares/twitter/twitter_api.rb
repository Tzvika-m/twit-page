module Twitter
  class TwitterApi

    def initialize(user)
      @user = user
    end

    def follow(uid)
      @user.twitter.follow(uid)
    end

    def sayhi(handle)
      @user.twitter.update("Hi @" + handle + " how are you today?")
    end

    def update_followers
      # Get all the user's followers
      followers = @user.twitter.followers.to_a

      # If it's the user's first login, insert all of them and mark the last 10% as new
      if Follower.where(user_id: @user.id).count == 0
        followers.each_with_index do |follower, index|
          is_new = (index >= (followers.count / 10.0) * 9)
          Follower.create(
            user_id: @user.id, 
            uid: follower.id,
            name: follower.name,
            handle: follower.screen_name,
            followers_count: follower.followers_count,
            picture: follower.profile_image_url.to_s,
            is_new: is_new
            )
        end
      else
        # Create a hash of all the user's old followers
        old_followers_uids = Follower.where("user_id =  ? AND unfollow_date IS NULL", @user.id).pluck(:uid)
        old_followers_hash = Hash[old_followers_uids.map {|uid| [uid, 1]}]

        followers.each do |follower|
          if old_followers_hash[follower.id.to_s]
            # Remove from the list followers that remained following
            old_followers_hash.delete(follower.id.to_s)  
          else
            # Insert new followers to the DB
            created_follower = Follower.create(
              user_id: @user.id, 
              uid: follower.id,
              name: follower.name,
              handle: follower.screen_name,
              followers_count: follower.followers_count,
              picture: follower.profile_image_url.to_s,
              is_new: true
            )
            # In case a member unfllowed and now refollowed
            if created_follower.id == nil
              Follower.where(user_id: @user_id, uid: follower.id).take.update(unfollow_date: nil, is_new: true)
            end
          end
        end

        # Mark old followers that did not remained following as unfollowers
        old_followers_hash.each do |uid|
          Follower.find_by(uid: uid).update(unfollow_date: Time.now)
        end
      end
    end
    
  end
end
