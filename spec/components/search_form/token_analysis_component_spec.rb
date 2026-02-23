# frozen_string_literal: true

require "rails_helper"

RSpec.describe SearchForm::TokenAnalysisComponent, type: :component do
  it "does not raise" do
    expect { described_class.new }.not_to raise_error
  end
end
