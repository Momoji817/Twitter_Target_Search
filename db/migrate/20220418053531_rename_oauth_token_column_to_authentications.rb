class RenameOauthTokenColumnToAuthentications < ActiveRecord::Migration[6.1]
  def change
    rename_column :authentications, :oauth_token, :encrypted_oauth_token
    rename_column :authentications, :oauth_token_secret, :encrypted_oauth_token_secret
  end
end
