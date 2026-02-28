# frozen_string_literal: true

require "rails_helper"

RSpec.describe Stats::SentencesPerArticleComponent, type: :component do
  it "renders the unit as `sentences`" do
    render_inline described_class.new(100)

    expect(page).to have_content(/100\s+sentences/)
  end
end
