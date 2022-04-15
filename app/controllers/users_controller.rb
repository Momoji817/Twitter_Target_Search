class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[show destroy]

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy!
    redirect_to root_path, notice: "#{@user.name}さんを削除しました"
  end
end
