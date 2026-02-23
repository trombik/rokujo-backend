# frozen_string_literal: true

require "rails_helper"

RSpec.describe Text::RubyComponent, type: :component do
  it "renders text with ruby" do
    render_inline(described_class.new("文章", "ぶんしょう"))

    expect(page).to have_css("ruby", text: "文章")
      .and have_css("ruby rt", text: "ぶんしょう")
      .and have_css("ruby rp", text: "(")
      .and have_css("ruby rp", text: ")")
  end
end
