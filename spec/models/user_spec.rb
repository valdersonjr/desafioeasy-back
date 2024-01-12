require 'rails_helper'

RSpec.describe User, type: :model do
  it_has_behavior_of "like searchable concern", :user, :login
  it_behaves_like "paginatable concern", :user

  it { is_expected.to validate_presence_of(:login)}
  it { is_expected.to validate_uniqueness_of(:login).case_insensitive}

  it { is_expected.to validate_presence_of(:name)}
end