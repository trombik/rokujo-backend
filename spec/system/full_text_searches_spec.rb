require "rails_helper"

RSpec.shared_context "with sentences" do
  let(:another_sentence) do
    create(:sentence, text: "さようなら",
                      article: create(
                        :article,
                        site_name: target_site_name,
                        url: "http://#{target_domain}/path2"
                      ))
  end
  let(:sentence) do
    create(:sentence, text: target,
                      article: create(
                        :article,
                        site_name: target_site_name,
                        url: "http://#{target_domain}/path1"
                      ))
  end
end

RSpec.shared_context "with matching keywords" do
  include_context "with sentences"

  let(:target) { "こんにちは" }
  let(:target_tag) { "ユニークなタグ" }
  let(:target_site_name) { "サイト" }
  let(:target_domain) { "example.org" }
  let(:keywords) do
    [
      target,
      "#{target}?",
      "#{target} foobar", # when multiple keywords are given, the first one is used and the rest are ignored.
      "#{target} site_name:\"#{target_site_name}\"",
      "#{target} url:#{target_domain}/path1",
      "#{target} url:#{target_domain}",
      "#{target} site_name:\"#{target_site_name}\" url:#{target_domain}",
      "site_name:\"#{target_site_name}\" #{target} url:#{target_domain}",
      "site_name:\"#{target_site_name}\" url:#{target_domain} #{target}",
      "#{target} tag:#{target_tag}",
      "#{target} tag:#{target_tag} url:example.net", # when a tag is given, other operators are ignored.
      "#{target} tag:#{target_tag} site_name:foo"
    ]
  end
end

RSpec.shared_context "with operators" do
  include_context "with matching keywords"

  let(:keywords) do
    [
      "site_name:\"#{target_site_name}\"",
      "url:#{target_domain}",
      "tag:#{target_tag}"
    ]
  end
end

RSpec.shared_context "with keywords that do not match" do
  include_context "with matching keywords"

  let(:keywords) do
    [
      "foobar",
      "foobar #{target}", # when multiple keywords are given, the first one is used and the rest are ignored.
      "site_name:\"Site X\"",
      "#{target} site_name:\"Site X\"",
      "siet_name:",
      "url:example.net",
      "#{target} url:example.net",
      "#{target} url:http://example.org",
      "url:",
      "tag:Foo",
      "#{target} tag:Foo", # when a tag is given, other operators are ignored.
      "#{target} tag:Foo site_name:\"#{target_site_name}\"",
      "#{target} tag:Foo url:#{target_domain}",
      "tag:"
    ]
  end
end

RSpec.describe "FullTextSearches", type: :system do
  include ERB::Util

  let(:word) { "" }
  let(:search_form) do
    form_test_id = SearchForm::FullTextComponent.testid_prefix
    find_by_testid_starting_with(form_test_id)
  end

  before do
    sentence
    another_sentence
    ac = create(:article_collection, key: "site_name", value: target_site_name)
    create(:collection_tag, name: target_tag, article_collections: [ac])
    visit sentences_index_path
  end

  context "when no word is given" do
    include_context "with matching keywords"

    it "shows no results" do
      within(search_form) do
        fill_in "Regular expression", with: word
        click_button "Search"
      end

      expect(page).to have_no_text(target)
    end
  end

  context "when the input matches any articles" do
    include_context "with matching keywords"

    it "all shows the matched sentence only" do
      keywords.each do |word|
        within(search_form) do
          fill_in "Regular expression", with: word
          click_button "Search"
        end

        expect(page).to have_text(sentence.text).and have_no_text(another_sentence.text)
      end
    end
  end

  context "when the operators matches the article" do
    include_context "with operators"

    it "shows both sentences" do
      keywords.each do |word|
        within(search_form) do
          fill_in "Regular expression", with: word
          click_button "Search"
        end

        expect(page).to have_text(sentence.text).and have_text(another_sentence.text)
      end
    end
  end

  context "when the keyword does not match" do
    include_context "with keywords that do not match"

    it "shows no results" do
      keywords.each do |word|
        within(search_form) do
          fill_in "Regular expression", with: word
          click_button "Search"
        end

        expect(page).to have_no_text(target).and have_no_text(another_sentence.text)
      end
    end
  end
end
