# frozen_string_literal: true

require "rails_helper"

RSpec.describe SearchForm::FullTextComponent, type: :component do
  it "does not raise" do
    expect { described_class.new }.not_to raise_error
  end

  context "when keyword is given" do
    specify "the keyword is pre-filled in the text field" do
      word = "foo"
      render_inline described_class.new(keyword: word)

      expect(page).to have_field("word", with: word)
    end
  end
end
