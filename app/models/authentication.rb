class Authentication < ApplicationRecord
  belongs_to :user
  attr_encrypted :access_token, :access_token_secret, key: 'This is a key that is 256 bits!!'

  validates :provider, presence: true
  validates :uid, presence: true
end
