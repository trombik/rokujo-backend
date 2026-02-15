# frozen_string_literal: true

require "rails_helper"

RSpec.describe Article::ContextComponent, type: :component do
  let(:sentences) { build_list(:sentence, 2) }
  let(:article) { create(:article, sentences: sentences) }
  let(:component) do
    sentence = article.sentences.first
    described_class.new(sentence, Sentence.context_sentences(sentence))
  end

  it "renders without rasing exception" do
    expect do
      render_inline(component)
    end.not_to raise_error
  end
end
