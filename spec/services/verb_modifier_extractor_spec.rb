require "rails_helper"

RSpec.describe VerbModifierExtractor do
  let(:service) { described_class.new(lemma: "行動") }

  before do
    create(:sentence, article: create(:article), text: "しっかり行動する。", analyze: true)
    create(:sentence, article: create(:article), text: "しっかり行動する。", analyze: true)
    create(:sentence, article: create(:article), text: "ゆっくり行動する。", analyze: true)
  end

  it "extracts modifers for the verb" do
    expect(service.call.keys).to contain_exactly("しっかり", "ゆっくり")
  end

  it "sorts by frequency" do
    expect(service.call.to_a.first).to contain_exactly("しっかり", 2)
  end
end
