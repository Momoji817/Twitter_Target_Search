class FollowingCandidatesController < ApplicationController
  require_relative '../services/get_following_service'
  require_relative '../services/get_followers_service'
  require_relative '../services/post_following_service'

  def index
    if params[:search].present?
      screen_name = params[:screen_name]
      followers_count_over = params[:followers_count_over]
      followers_count_less = params[:followers_count_less].presence || 1000000000
      friends_count_over = params[:friends_count_over]
      friends_count_less = params[:friends_count_less].presence || 1000000000
      created_at = params[:created_at].presence || "1000-01-03 01:10:00 +0900"
      keyword = params[:keyword]
      
      @following = GetFollowingService.new(current_user).get_following
      @followers = GetFollowersService.new(current_user, screen_name).get_followers.delete("users")
      @followers.reject!{|x| x["id_str"].in?(@following)}

      @results = @followers.find_all{
        |x| x["followers_count"].to_i >= followers_count_over.to_i && 
            x["followers_count"].to_i <= followers_count_less.to_i && 
            x["friends_count"].to_i >= friends_count_over.to_i && 
            x["friends_count"].to_i <= friends_count_less.to_i && 
            x["created_at"] >= created_at && 
            x["description"].include?(keyword)
      }
    end
  end

  def following
    if params[:following].present?
      target_user_id = params[:target_user_id]
      binding.pry
      @following_result = PostFollowingService.new(current_user, target_user_id).post_following
    binding.pry
    end
  end
end
