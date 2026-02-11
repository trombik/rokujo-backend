require "rails_helper"

RSpec.describe Article, type: :model do
  describe "associattion" do
    it { is_expected.to have_many :sentences }
  end

  describe "validation" do
    subject { build(:article) }

    it { is_expected.to validate_presence_of :uuid }
    it { is_expected.to validate_uniqueness_of :uuid }
    it { is_expected.to validate_length_of :sentences }

    context "when sentences is an empty array" do
      it "raises" do
        obj = build(:article, sentences: [])

        expect { obj.save! }.to raise_error ActiveRecord::RecordInvalid
      end
    end

    context "when sentences is not an empty array" do
      it "raises" do
        obj = build(:article, sentences: [build(:sentence)])

        expect { obj.save! }.not_to raise_error
      end
    end
  end
end
