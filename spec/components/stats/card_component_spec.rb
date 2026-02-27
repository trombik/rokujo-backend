# frozen_string_literal: true

require "rails_helper"

RSpec.describe Stats::CardComponent, type: :component do
  before do
    render_inline described_class.new do |c|
      c.with_title { "My title" }
      "My content"
    end
  end

  it "renders title" do
    expect(page).to have_content(/My title/)
  end

  it "renders content" do
    expect(page).to have_content(/My content/)
  end
end
