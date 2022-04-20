class User < ApplicationRecord
  authenticates_with_sorcery!

  has_one :authentication, dependent: :destroy
  accepts_nested_attributes_for :authentication

  validates :name, presence: true, length: { maximum: 50 }
  validates :profile_image_url, presence: true
  validates :role, presence: true

  enum role: { general: 0, admin: 1 }
end
