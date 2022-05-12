class FollowingCandidatesController < ApplicationController
  require_relative '../services/get_ids_service'

  def index; end

  def get_ids
    username = params[:username]
    GetIdsService.new(current_user, username).get_ids
  end
end
