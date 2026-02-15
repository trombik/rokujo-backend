# frozen_string_literal: true

require "rails_helper"

RSpec.describe Sentence::CardComponent, type: :component do
  let(:article) { create(:article) }
  let(:sentence) { create(:sentence, article: article, text: "foo bar buz") }
  let(:component) { described_class.new(sentence, "bar") }

  describe "#new" do
    it "does not raise" do
      expect { component }.not_to raise_error
    end
  end

  describe "#published_year" do
    context "when published_time is not empty" do
      it "returns %Y of published_time" do
        article.published_time = Time.zone.parse("1983/1/1")
        article.acquired_time = Time.zone.parse("2000/1/1")
        expect(component.published_year).to eq "1983"
      end
    end

    context "when published_time is empty" do
      it "returns %Y of acquired_time" do
        article.published_time = ""
        article.acquired_time = Time.zone.parse("2000/1/1")
        expect(component.published_year).to eq "2000"
      end
    end

    context "when both published_time and acquired_time are empty" do
      it "returns Unknown year" do
        article.published_time = ""
        article.acquired_time = ""
        expect(component.published_year).to be false
      end
    end
  end

  describe "#article_site_name" do
    it "truncates a long site name" do
      article.site_name = "X" * 255
      expect(component.article_site_name).to end_with("…")
    end

    context "when article has site_name" do
      it "returns site_name" do
        article.site_name = "A site"
        expect(component.article_site_name).to eq "A site"
      end
    end

    context "when article does not have a site_name" do
      it "returns No site name" do
        article.site_name = ""
        expect(component.article_site_name).to be false
      end
    end
  end

  describe "#decorated_text" do
    it "highlights matched word" do
      expect(component.decorated_text).to match(%r{<span [^>]+>bar</span>})
    end
  end
end
