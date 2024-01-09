require 'rails_helper'

RSpec.describe Load, type: :model do
    it { is_expected.to validate_presence_of(:delivery_date)}
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive}

end