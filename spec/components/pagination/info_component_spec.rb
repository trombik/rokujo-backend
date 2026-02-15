# frozen_string_literal: true

require "rails_helper"
require "pagy/console"

RSpec.describe Pagination::InfoComponent, type: :component do
  let(:sentences) { build_list(:sentence, 50) }
  let(:article) { create(:article, sentences: sentences) }

  describe "#total_count" do
    it "counts the total number of items" do
      article
      page, _sentences = pagy(:countish, Sentence.all, items: 20)
      expect(described_class.new(page).total_count).to eq sentences.size
    end
  end
end
