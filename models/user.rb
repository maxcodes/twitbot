require "active_record"
class User < ActiveRecord::Base

  establish_connection(adapter: "postgresql", database: "twitters")

  MY_USERNAME = "maxholzheu".freeze

  def self.we_are_not_following
    where.not(we_currently_follow_them: true).
      where.not(we_followed_them_in_the_past: true)
  end

  def self.we_are_following
    where(we_currently_follow_them: true)
  end

  def follow!
    client.follow!(user_id)
    update!(we_currently_follow_them: true)
    puts "followed #{user_id}"
  rescue Twitter::Error::Forbidden
    puts "couldn't follow #{user_id}"
    update!(we_currently_follow_them: true)
  end

  def unfollow!
    client.unfollow(user_id)
    puts "unfollowed #{user_id}"
    update!(we_currently_follow_them: false, we_followed_them_in_the_past: true)
  rescue Twitter::Error::NotFound
    puts "couldn't unfollow #{user_id}"
    destroy
  end

  def follower_ids(num = 50)
    client.follower_ids(user_id).to_h.first.second.first(num)
  rescue
    []
  end

  def following_ids(num = 50)
    client.following(user_id).to_h[:users].map { |hash| hash[:id] }.first(num)
  rescue
    []
  end

  def self.follows?(client, id)
    ENV["SKIP_FOLLOW_CHECK"].nil? && client.friendship?(MY_USERNAME, id)
  rescue Twitter::Error::TooManyRequests => error
    sleep_time = error.rate_limit.reset_in + 1
    puts "sleeping for #{sleep_time} (rate limit hit)"
    sleep sleep_time
    retry
  end

  private

  def client
    require "./services/twitter_client"
    @_client ||= TwitterClient.new
  end

end
