# frozen_string_literal: true

require "rails_helper"

RSpec.describe Collocations::ModifierComponent, type: :component do
  let(:component) { described_class.new("amod", "名詞", result) }
  let(:result) { {} }

  before do
    render_inline component
  end

  it "renders the component" do
    expect(page).to have_component(described_class)
  end

  it "renders 形容詞修飾" do
    expect(page).to have_content("形容詞修飾")
  end

  it "does not render a button to toggle collapsed part" do
    expect(page).to have_no_component(described_class::ToggleButton)
  end

  context "when less_frequent_words is given" do
    let(:result) do
      {
        "表示される" => 10,
        "表示されない" => 1
      }
    end

    it "renders a button to toggle collapsed part" do
      within find_component(described_class, match: :first) do
        expect(page).to have_component(described_class::ToggleButton)
      end
    end
  end
end
