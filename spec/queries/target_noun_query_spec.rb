require "rails_helper"

RSpec.describe TargetNounQuery, type: :query do
  let(:query) { described_class.new(lemma: lemma) }
  let(:article) { create(:article) }
  let(:lemma) { "データ" }

  before do
    create(:sentence, article: article, text: "データを作成する")
    create(:sentence, article: article, text: "データを利用する")
  end

  it "returns target noun" do
    expect(query.call.map(&:lemma)).to all(include lemma)
  end

  specify "all tokens are NOUN" do
    expect(query.call.map(&:pos)).to all(eq("NOUN"))
  end

  context "with nil lemma" do
    let(:lemma) { nil }

    it "returns none" do
      expect(query.call).to be_empty
    end
  end
end
