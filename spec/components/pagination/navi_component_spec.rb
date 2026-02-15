# frozen_string_literal: true

require "rails_helper"
require "pagy/console"

RSpec.describe Pagination::NaviComponent, type: :component do
  let(:sentences) { build_list(:sentences, 50) }
  let(:article) { create(:article, sentences: sentences) }

  it "renders the navigation" do
    page, _sentences = pagy(:countish, Sentence.all, items: 20)
    expect do
      render_inline(described_class.new(page))
    end.not_to raise_error
  end
end
