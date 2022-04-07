class SorceryCore < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :profile_image_url, default: "https://abs.twimg.com/sticky/default_profile_images/default_profile.png", null: false
      t.string :account_url, null: false
      t.integer :role, default: 0, null: false

      t.timestamps                null: false
    end
  end
end
