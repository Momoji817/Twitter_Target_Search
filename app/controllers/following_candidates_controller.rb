class FollowingCandidatesController < ApplicationController
  require_relative '../services/get_followers_service'

  def index; end

  def call
    screen_name = params[:screen_name]
    @result = GetFollowersService.new(current_user, screen_name).get_followers
    render :index
  end
end
