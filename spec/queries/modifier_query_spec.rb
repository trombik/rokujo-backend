require "rails_helper"

RSpec.describe ModifierQuery, type: :query do
  let(:modifiers) { described_class.new(targets, deps: deps).call }
  let(:targets) { TargetNounQuery.new(lemma: lemma).call }
  let(:lemma) { "データ" }
  let(:texts) { ["視線という生体測定データ"] }

  before do
    create_list(:sentence, texts.size, article: create(:article)) do |sentence, index|
      sentence.text = texts[index]
      sentence.save!
      sentence.analyze_and_store_pos!
    end
  end

  context "with nmod" do
    let(:deps) { %w[nmod] }

    it "extracts nmod modifier tokens for the given nouns" do
      expect(modifiers.pluck(:text)).to contain_exactly("視線")
    end
  end

  context "with compound" do
    let(:deps) { %w[compound] }

    it "extracts compound modifier tokens for the given nouns" do
      expect(modifiers.pluck(:text)).to contain_exactly("生体", "測定")
    end
  end
end
