require "rails_helper"

RSpec.describe "CollapsedClipboard", :js, type: :system do
  let(:expected_value) { "019c4dbc-7941-7ae6-8d27-5d40d35ee96e" }

  let(:clip_text_component) do
    clip_text_component_testid = Shared::ClipTextComponent.testid
    "[data-testid='#{clip_text_component_testid}']:has(input[value='#{expected_value}'])"
  end

  before do
    article = create(:article, uuid: expected_value, url: "http://example.org/path")
    create(:sentence, text: "foo bar buz", article: article)
    visit search_path
    within "form[action='/search']" do
      fill_in "Regular expression", with: "foo\\s+bar"
      click_on "Search"
    end
  end

  it "allows users to copy the value" do
    expect(page).to have_text(/foo\s+bar/)

    target_card = first(".card", text: /foo\s+bar/)
    within target_card do
      click_button "UUID"

      expect(page).to have_css(clip_text_component, visible: :visible)

      target_component = find(clip_text_component, visible: :visible)
      within target_component do
        click_button
      end
    end

    clipboard_content = page.evaluate_async_script <<~JS
      const callback = arguments[arguments.length - 1];
      navigator.clipboard.readText().then(callback);
    JS
    expect(clipboard_content).to eq expected_value
  end
end
