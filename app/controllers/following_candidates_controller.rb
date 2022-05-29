class FollowingCandidatesController < ApplicationController
  require_relative '../services/get_followers_service'

  def index; end

  def call
    screen_name = params[:screen_name]
    GetFollowersService.new(current_user, screen_name).get_followers
    render action: :index
  end
end
