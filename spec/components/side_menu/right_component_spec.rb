# frozen_string_literal: true

require "rails_helper"

RSpec.describe SideMenu::RightComponent, type: :component do
  describe ".id" do
    it "is a parameterize class name" do
      id = described_class.id
      expect(id.tr("-", "/").classify.constantize).to eq described_class
    end
  end
end
