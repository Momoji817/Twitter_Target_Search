class FollowingCandidatesController < ApplicationController
  require_relative '../services/get_followers_service'

  def index
    screen_name = params[:screen_name]
    followers_count_over = params[:followers_count_over]
    followers_count_less = params[:followers_count_less] 
    friends_count_over = params[:friends_count_over]
    friends_count_less = params[:friends_count_less]
    created_at = params[:created_at]
    keyword = params[:keyword]                           
    
    if params[:search] == "検索"
      @followers = GetFollowersService.new(current_user, screen_name).get_followers.delete("users")
      @result = @followers.find_all{
        |x| x["followers_count"].to_i >= followers_count_over.to_i && 
        x["followers_count"].to_i <= followers_count_less.to_i && 
        x["friends_count"].to_i >= friends_count_over.to_i && 
        x["friends_count"].to_i <= friends_count_less.to_i && 
        x["created_at"].to_time >= created_at && 
        x["description"].include?(keyword)
      }
    end
  end
end
