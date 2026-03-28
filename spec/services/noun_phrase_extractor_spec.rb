require "rails_helper"

RSpec.describe NounPhraseExtractor, type: :model do
  subject { extractor.call.keys }

  let(:lemma) { "データ" }
  let(:extractor) { described_class.new(lemma: lemma, deps: deps) }

  before do
    # Create sample sentence and associated article for the test case.
    create(:sentence, article: create(:article), text: text)
  end

  describe "dependency: acl (Adnominal Clause)" do
    let(:deps) { ["acl"] }

    context "when modified by an adverbial phrase (非常に重要な)" do
      let(:text) { "非常に重要なデータ" }

      # RATIONALE: "非常に" (advmod) is excluded to maintain a generalized "type" or "pattern".
      # We focus on the core adjectival modification "重要な".
      it { is_expected.to contain_exactly("重要な") }
    end

    context "when modified by multiple clauses (学習した膨大な)" do
      let(:text) { "学習した膨大なデータ" }

      it { is_expected.to contain_exactly("学習した", "膨大な") }
    end

    context "when mixed with compound nouns (膨大な顧客データ)" do
      let(:text) { "膨大な顧客データ" }

      # RATIONALE: "顧客" is a 'compound' or 'nmod' dependency. Since 'deps' only includes 'acl',
      # non-matching dependencies are strictly filtered out.
      it { is_expected.to contain_exactly("膨大な") }
    end

    context "when including verbal and adjectival modifiers (保有する多彩な)" do
      let(:text) { "保有する多彩なデータ" }

      it { is_expected.to contain_exactly("保有する", "多彩な") }
    end

    context "when the same lemma appears multiple times with different modifiers" do
      let(:text) { "管理しているデータと管理されているデータ" }

      it { is_expected.to contain_exactly("管理している", "管理されている") }
    end
  end

  describe "dependency: nmod (Noun Modifier)" do
    let(:deps) { ["nmod"] }

    context "when indicating possession or belonging (ユーザーのデータ)" do
      let(:text) { "ユーザーのデータ" }

      # RATIONALE: "ユーザーの" is essential context to identify the entity in translation (e.g., "User data").
      it { is_expected.to contain_exactly("ユーザーの") }
    end

    context "when indicating attributes or categories (テキスト形式のデータ)" do
      let(:text) { "テキスト形式のデータ" }

      # RATIONALE: By extracting "形式の", we identify a reusable translation pattern.
      # "テキスト" is a nested modifier of "形式" and is excluded to avoid over-specification.
      it { is_expected.to contain_exactly("形式の") }
    end

    context "when using complex case particles (クラウド上のデータ)" do
      let(:text) { "クラウド上のデータ" }

      # RATIONALE: Extracts "上の" as the direct functional modifier of the target.
      it { is_expected.to contain_exactly("上の") }
    end

    context "when noise is present in the sentence (昨日の膨大なデータ)" do
      let(:text) { "昨日の膨大なデータ" }

      # RATIONALE: "膨大な" is an 'acl' dependency. It is correctly ignored when 'deps' is restricted to 'nmod'.
      it { is_expected.to contain_exactly("昨日の") }
    end
  end
end
