require 'rails_helper'

RSpec.describe Product, type: :model do

    it_has_behavior_of "like searchable concern", :product, :name
    it_behaves_like "paginatable concern", :product

    it { is_expected.to validate_presence_of(:name)}
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive}

    it { is_expected.to validate_presence_of(:ballast)}

    it { is_expected.to validate_numericality_of(:ballast).is_greater_than(0)}
end