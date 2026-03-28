# frozen_string_literal: true

require "rails_helper"

RSpec.describe Sentence::CardComponent, type: :component do
  let(:article) { create(:article) }
  let(:sentence) { create(:sentence, article: article, text: "foo bar buz") }
  let(:component) { described_class.new(sentence, "bar") }

  before do
    render_inline component
  end

  context "when published_time is not empty" do
    let(:article) do
      create(:article, published_time: Time.zone.parse("1983/1/1"), acquired_time: Time.zone.parse("2000/1/1"))
    end

    specify "year is based on published_time" do
      within find_by_testid("year") do
        expect(page).to have_text("1983")
      end
    end
  end

  context "when published_time is empty" do
    let(:article) do
      create(:article, published_time: "", acquired_time: Time.zone.parse("2000/1/1"))
    end

    specify "year is based on acquired_time" do
      within find_by_testid("year") do
        expect(page).to have_text("2000")
      end
    end
  end

  context "when both published_time and acquired_time are empty" do
    let(:article) do
      create(:article, published_time: "", acquired_time: "")
    end

    it "renders Unknown year" do
      expect(component.published_year).to be false
      within find_by_testid("year") do
        expect(page).to have_text("Unknown year")
      end
    end
  end

  context "when site name is too long" do
    let(:article) do
      create(:article, site_name: "X" * 255)
    end

    it "truncates a long site name" do
      within find_by_testid("year") do
        expect(page).to have_text("…")
      end
    end
  end

  context "when article has site_name" do
    let(:article) { create(:article, site_name: "A site") }

    it "renders site_name" do
      within find_by_testid("year") do
        expect(page).to have_text("A site")
      end
    end
  end

  context "when article does not have a site_name" do
    let(:article) { create(:article, site_name: "") }

    it "renders No site name" do
      within find_by_testid("year") do
        expect(page).to have_text("No site name")
      end
    end
  end

  describe "#decorated_text" do
    it "highlights matched word" do
      within find_component(described_class) do
        expect(page).to have_css("span", content: "bar")
      end
    end
  end
end
