class RenameEncryptedOauthTokenColumnToAuthentications < ActiveRecord::Migration[6.1]
  def change
    rename_column :authentications, :encrypted_oauth_token, :encrypted_access_token
    rename_column :authentications, :encrypted_oauth_token_secret, :encrypted_access_token_secret
    rename_column :authentications, :encrypted_oauth_token_iv, :encrypted_access_token_iv
    rename_column :authentications, :encrypted_oauth_token_secret_iv, :encrypted_access_token_secret_iv
  end
end
