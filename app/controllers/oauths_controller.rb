class OauthsController < ApplicationController
  skip_before_action :require_login

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if (@user = login_from(provider))
      @user.authentication.update!(
        access_token: access_token.token,
        access_token_secret: access_token.secret
      )
    else
      fetch_user_data_from(provider)
    end
    redirect_to following_candidates_path
  end

  private

  def auth_params
    params.permit(:code, :provider, :oauth_token, :oauth_verifier)
  end

  def fetch_user_data_from(provider)
    user_from_provider = build_from(provider)
    @user = user_from_provider if @user.new_record?
    @user.build_authentication(uid: @user_hash[:uid],
                               provider: provider,
                               access_token: access_token.token,
                               access_token_secret: access_token.secret)
    @user.save!
    reset_session
    auto_login(@user)
  end
end
