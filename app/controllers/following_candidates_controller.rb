class FollowingCandidatesController < ApplicationController
  require_relative '../services/get_ids_service'
  require_relative '../services/get_followers_service'

  def index; end

  def call
    username = params[:username]
    user_id = GetIdsService.new(current_user, username).get_ids
    GetFollowersService.new(current_user, user_id).get_followers
  end
end
