class FollowingCandidatesController < ApplicationController
  require_relative '../services/get_following_service'
  require_relative '../services/get_followers_service'
  require_relative '../services/post_following_service'

  def index
    if params[:search].present?
      screen_name = params[:screen_name]
      followers_count_over = params[:followers_count_over]
      followers_count_less = params[:followers_count_less].presence || 10_000_000
      friends_count_over = params[:friends_count_over]
      friends_count_less = params[:friends_count_less].presence || 10_000_000
      created_at = params[:created_at].presence || '1000-01-03 01:10:00 +0000'
      keyword = params[:keyword]
      next_cursor = params[:next_cursor]

      @following = GetFollowingService.new(current_user).get_following

      if @following == 'error'
        return @results = 'too_many_requests'
      end

      @followers_result = GetFollowersService.new(current_user, screen_name, next_cursor).get_followers

      if @followers_result.any? { |k, _v| k == 'errors' }
        return @results = 'screen_name_error'
      end

      @next_cursor = @followers_result['next_cursor']
      @followers = @followers_result['users']
      @followers.reject! { |x| x['id_str'].in?(@following) }
      @followers.reject! { |x| x['protected'] }

      @results = @followers.find_all do |x|
        x['followers_count'].to_i >= followers_count_over.to_i &&
          x['followers_count'].to_i <= followers_count_less.to_i &&
          x['friends_count'].to_i >= friends_count_over.to_i &&
          x['friends_count'].to_i <= friends_count_less.to_i &&
          x['created_at'].in_time_zone('Tokyo').strftime('%Y/%m/%d') >= created_at &&
          x['description'].include?(keyword)
      end
    end
  end

  def following
    if params[:following].present?
      target_user_id = params[:target_user_id]
      @following_result = PostFollowingService.new(current_user, target_user_id).post_following
      @target_user_id = target_user_id
    end
  end
end
