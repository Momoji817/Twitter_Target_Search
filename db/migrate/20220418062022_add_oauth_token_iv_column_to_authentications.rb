class AddOauthTokenIvColumnToAuthentications < ActiveRecord::Migration[6.1]
  def change
    add_column :authentications, :encrypted_oauth_token_iv, :string, null: false
    add_column :authentications, :encrypted_oauth_token_secret_iv, :string, null: false
  end
end
