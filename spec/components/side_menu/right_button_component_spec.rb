# frozen_string_literal: true

require "rails_helper"

RSpec.describe SideMenu::RightButtonComponent, type: :component do
  it "does not raise error" do
    expect do
      described_class.new
    end.not_to raise_error
  end
end
