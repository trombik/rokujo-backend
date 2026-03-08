require "rails_helper"

TARGET = "こんにちは".freeze

RSpec.describe "FullTextSearches", type: :system do
  include ERB::Util

  let!(:sentence) do
    create(:sentence, text: TARGET,
                      article: create(
                        :article,
                        site_name: "Site name",
                        url: "http://example.org/path"
                      ))
  end
  let(:word) { "" }

  before do
    driven_by(:rack_test)

    ac = create(:article_collection, key: "site_name", value: "Site name")
    create(:collection_tag, name: "Example", article_collections: [ac])

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
    "site_name:\"Site name\"",
    "#{TARGET} site_name:\"Site name\"",
    "#{TARGET} url:example.org/path",
    "#{TARGET} url:example.org",
    "#{TARGET} site_name:\"Site name\" url:example.org",
    "site_name:\"Site name\" #{TARGET} url:example.org",
    "site_name:\"Site name\" url:example.org #{TARGET}",
    "#{TARGET} tag:Example",
    "#{TARGET} tag:Example url:example.net", # when a tag is given, other operators are ignored.
    "#{TARGET} tag:Example site_name:foo"
  ].each do |keyword|
    context "when keyword is `#{keyword}`" do
      let(:word) { keyword }

      it "shows the sentence" do
        expect(page).to have_text(sentence.text)
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
    "url:",
    "tag:Foo",
    "#{TARGET} tag:Foo", # when a tag is given, other operators are ignored.
    "#{TARGET} tag:Foo site_name:\"Site name\"",
    "#{TARGET} tag:Foo url:example.org",
    "tag:"
  ].each do |keyword|
    context "when keyword is `#{keyword}`" do
      let(:word) { keyword }

      it "shows no results" do
        expect(page).to have_no_text(TARGET)
      end
    end
  end
end
