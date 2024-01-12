require 'rails_helper'

RSpec.describe Load, type: :model do
    it_has_behavior_of "like searchable concern", :load, :code
    it_behaves_like "paginatable concern", :load

    it { is_expected.to validate_presence_of(:delivery_date)}
    it { is_expected.to validate_presence_of(:code)}
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive}

end