require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    before { build(:user) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
    it { is_expected.to validate_presence_of(:profile_image_url) }
  end

  describe 'associations' do
    it { should have_one(:authentication).dependent(:destroy) }
  end
end
