require "rails_helper"

RSpec.describe Sentence, type: :model do
  describe "associattion" do
    it { is_expected.to belong_to :article }
  end

  describe "validation" do
    it { is_expected.to validate_presence_of :line_number }
    it { is_expected.to validate_presence_of :text }
  end
end
