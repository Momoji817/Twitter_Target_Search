class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :name, presence: true, length: { maximum: 50 }
  validates :profile_image_url, presence: true
  validates :account_url, presence: true
  validates :role, presence: true

  enum role: { general: 0, admin: 1 }
end
