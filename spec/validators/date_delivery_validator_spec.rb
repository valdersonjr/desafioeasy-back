require "rails_helper"

class DeliveryDateValidator
  include ActiveModel::Validations
  attr_accessor :date
  validates :date, delivery_date: false
end

describe DeliveryDateValidator do
  subject { DeliveryDateValidator.new }

  context "when date is before current date" do
    before { subject.date = 1.day.ago }

    it "should be valid" do
      expect(subject.valid?).to be_truthy
    end
  end

  context "when date is equal current date" do
    before { subject.date = Time.zone.now }

    it "should be valid" do
      expect(subject.valid?).to be_truthy
    end
  end

  context "when date is greater than current date" do
    before { subject.date = Time.zone.now + 1.day }

    it "should be invalid" do
      expect(subject.valid?).to be_falsey
    end

    it "adds an error on model" do
      subject.valid?
      expect(subject.errors.keys).to include(:date)
    end
  end
end