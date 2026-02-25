# frozen_string_literal: true

require "rails_helper"

RSpec.describe SpinnerComponent, type: :component do
  it "does not raise" do
    expect do
      described_class.new
    end.not_to raise_error
  end
end
