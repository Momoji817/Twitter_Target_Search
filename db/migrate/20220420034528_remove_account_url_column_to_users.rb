class RemoveAccountUrlColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :account_url, :string, null: false
  end
end
