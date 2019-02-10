require "./models/user"
class Scripts

  def self.follow_people!
    return if Time.now.hour < 8

    lucky_one = User.we_are_not_following.first
    lucky_one.follow!

    followers = lucky_one.follower_ids(50)
    following = lucky_one.following_ids(50)

    (followers + following).each do |id|
      User.find_or_create_by(user_id: id)
    end
  end

  def self.unfollow_people!
    return if Time.now.hour < 8
    lucky_one = User.we_are_following.first
    puts("no more people to unfollow") && return unless lucky_one
    lucky_one.unfollow!
  end

end
