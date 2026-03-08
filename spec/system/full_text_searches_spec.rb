require "rails_helper"

TARGET = "こんにちは".freeze
TARGET_TAG = "ユニークなタグ".freeze
TARGET_SITE_NAME = "サイト".freeze
TARGET_DOMAIN = "example.org".freeze

RSpec.describe "FullTextSearches", type: :system do
  include ERB::Util

  let!(:another_sentence) do
    create(:sentence, text: "さようなら",
                      article: create(
                        :article,
                        site_name: TARGET_SITE_NAME,
                        url: "http://#{TARGET_DOMAIN}/path2"
                      ))
  end
  let!(:sentence) do
    create(:sentence, text: TARGET,
                      article: create(
                        :article,
                        site_name: TARGET_SITE_NAME,
                        url: "http://#{TARGET_DOMAIN}/path1"
                      ))
  end
  let(:word) { "" }

  before do
    driven_by(:rack_test)

    ac = create(:article_collection, key: "site_name", value: TARGET_SITE_NAME)
    create(:collection_tag, name: TARGET_TAG, article_collections: [ac])

    visit search_path
    within(format("form[action='%s']", search_path)) do
      fill_in "Regular expression", with: word
      click_button "Search"
    end
  end

  context "when no word is given" do
    it "shows no results" do
      expect(page).to have_no_text(TARGET)
    end
  end

  [
    TARGET,
    "#{TARGET}?",
    "#{TARGET} foobar", # when multipul keywords are given, the first one is used and the rest are ignored.
    "#{TARGET} site_name:\"#{TARGET_SITE_NAME}\"",
    "#{TARGET} url:#{TARGET_DOMAIN}/path1",
    "#{TARGET} url:#{TARGET_DOMAIN}",
    "#{TARGET} site_name:\"#{TARGET_SITE_NAME}\" url:#{TARGET_DOMAIN}",
    "site_name:\"#{TARGET_SITE_NAME}\" #{TARGET} url:#{TARGET_DOMAIN}",
    "site_name:\"#{TARGET_SITE_NAME}\" url:#{TARGET_DOMAIN} #{TARGET}",
    "#{TARGET} tag:#{TARGET_TAG}",
    "#{TARGET} tag:#{TARGET_TAG} url:example.net", # when a tag is given, other operators are ignored.
    "#{TARGET} tag:#{TARGET_TAG} site_name:foo"
  ].each do |keyword|
    context "when keyword is `#{keyword}`" do
      let(:word) { keyword }

      it "shows the matched sentence only" do
        expect(page).to have_text(sentence.text).and have_no_text(another_sentence.text)
      end
    end
  end
  [
    "site_name:\"#{TARGET_SITE_NAME}\"",
    "url:#{TARGET_DOMAIN}",
    "tag:#{TARGET_TAG}"
  ].each do |keyword|
    context "when the operator (`#{keyword}`) matches the article" do
      let(:word) { keyword }

      it "shows both sentences" do
        expect(page).to have_text(sentence.text).and have_text(another_sentence.text)
      end
    end
  end

  [
    "foobar",
    "foobar #{TARGET}", # when multipul keywords are given, the first one is used and the rest are ignored.
    "site_name:\"Site X\"",
    "#{TARGET} site_name:\"Site X\"",
    "siet_name:",
    "url:example.net",
    "#{TARGET} url:example.net",
    "#{TARGET} url:http://example.org",
    "url:",
    "tag:Foo",
    "#{TARGET} tag:Foo", # when a tag is given, other operators are ignored.
    "#{TARGET} tag:Foo site_name:\"#{TARGET_SITE_NAME}\"",
    "#{TARGET} tag:Foo url:#{TARGET_DOMAIN}",
    "tag:"
  ].each do |keyword|
    context "when keyword is `#{keyword}`" do
      let(:word) { keyword }

      it "shows no results" do
        expect(page).to have_no_text(TARGET).and have_no_text(another_sentence.text)
      end
    end
  end
end
