class SorceryExternal < ActiveRecord::Migration[6.1]
  def change
    create_table :authentications do |t|
      t.integer :user_id, null: false
      t.string :provider, :uid, null: false
      t.string :oauth_token, null: false
      t.string :oauth_token_secret, null: false

      t.timestamps              null: false
    end

    add_index :authentications, [:provider, :uid, :user_id]
  end
end
