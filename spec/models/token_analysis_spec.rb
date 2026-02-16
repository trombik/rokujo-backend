require "rails_helper"

RSpec.describe TokenAnalysis, type: :model do
  describe "associattion" do
    it { is_expected.to belong_to :sentence }
  end
end
