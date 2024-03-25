require 'rails_helper'

RSpec.describe Order, type: :model do

  it_behaves_like "like searchable concern", :order, :code
  it_behaves_like "paginatable concern", :order

  subject { FactoryBot.create(:order) }
  
    it { is_expected.to belong_to(:load) }
    it { is_expected.to have_many(:order_products).dependent(:destroy) }

    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:bay) }
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive}
    it { is_expected.to validate_presence_of(:load_id) }

end