require 'rails_helper'

RSpec.describe OrderProduct, type: :model do

    it { is_expected.to belong_to(:order) }
    it { is_expected.to belong_to(:product) }

    it { is_expected.to validate_presence_of(:quantity) }

    subject { FactoryBot.create(:order_product) }
    it { is_expected.to validate_uniqueness_of(:product_id).scoped_to(:order_id) }
end