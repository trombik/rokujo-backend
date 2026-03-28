require "rails_helper"

RSpec.describe PhraseReconstructor do
  let(:text) { "視線という生体測定データ" }
  let!(:sentence) { create(:sentence, article: create(:article), text: text) }
  let(:all_tokens) { sentence.token_analyses.to_a }

  describe ".call" do
    context "when starting with nmod '視線' (gaze)" do
      # In "視線という", "視線" is the head and "という" is a fixed particle pointing to it.
      let(:modifier) { sentence.token_analyses.find_by(text: "視線") }

      it "reconstructs the phrase including functional particles" do
        expect(described_class.call(modifier, all_tokens)).to eq("視線という")
      end

      it "does not include the neighboring compound '生体測定' (biometric)" do
        # RATIONALE: We must ensure that the reconstruction strictly follows
        # the dependency tree and doesn't bleed into adjacent but unrelated noun phrases.
        result = described_class.call(modifier, all_tokens)
        expect(result).not_to include("生体測定")
      end
    end

    context "when starting with a compound token '生体' (bio) with no children" do
      let(:modifier) { sentence.token_analyses.find_by(text: "生体") }

      it "returns only the specific token if it has no linguistic descendants" do
        expect(described_class.call(modifier, all_tokens)).to eq("生体")
      end
    end

    context "when an amod '具体的' (specific) appears at the beginning of a sentence" do
      # RATIONALE: This case tests edge cases where dependency parsers might assign
      # a 'head: 0' (root) to a modifier if it lacks a clear parent in short fragments.
      let(:text) { "具体的なデータです。" }
      let(:sentence) { create(:sentence, text: text) }
      let(:all_tokens) { sentence.token_analyses.to_a }
      let(:modifier) { sentence.token_analyses.find_by(text: "具体的") }

      it "reconstructs '具体的な' by capturing the auxiliary particle 'な'" do
        # NOTE: If the dependency structure is broken (head: 0), this test highlights
        # the need for a fallback mechanism or ensures current tree traversal logic is robust.
        expect(described_class.call(modifier, all_tokens)).to eq("具体的な")
      end
    end

    context "when an amod '膨大' (vast) appears in the middle of a sentence" do
      let(:text) { "これは膨大なデータです。" }
      let(:sentence) { create(:sentence, text: text) }
      let(:all_tokens) { sentence.token_analyses.to_a }
      let(:modifier) { sentence.token_analyses.find_by(text: "膨大") }

      it "follows the dependency structure to correctly attach the particle 'な'" do
        # RATIONALE: Verifies that standard adjectival modification is correctly
        # resolved through the tree traversal (amod -> aux/particle).
        expect(described_class.call(modifier, all_tokens)).to eq("膨大な")
      end
    end
  end
end
