# frozen_string_literal: true

require "rails_helper"

RSpec.describe Collocations::ModifiersForVerbComponent, type: :component do
  let(:component) { described_class.new(verb, results) }
  let(:verb) { "行動" }
  let(:results) do
    VerbModifierExtractor.new(lemma: verb).call
  end

  before do
    create(:sentence, article: create(:article), text: "前もって行動する。", analyze: true)
    create(:sentence, article: create(:article), text: "しっかり行動する。", analyze: true)
    render_inline component
  end

  it "renders the component" do
    expect(page).to have_component(described_class)
  end

  it "renders modifiers" do
    expect(page).to have_text("前もって").and have_text("しっかり")
  end
end
