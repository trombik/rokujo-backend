require "rails_helper"

RSpec.describe "CollapsedClipboard", :js, type: :system do
  let(:expected_value) { "019c4dbc-7941-7ae6-8d27-5d40d35ee96e" }

  before do
    article = create(:article, uuid: expected_value, url: "http://example.org/path")
    create(:sentence, text: "foo bar buz", article: article)
    visit search_path

    # grant permissions to read and write clipboard
    # https://playwright-ruby-client.vercel.app/docs/api/browser_context#clear_permissions
    browser_type = Capybara.current_session
                           .driver
                           .instance_variable_get("@browser_runner")
                           .instance_variable_get("@runner")
                           .instance_variable_get("@browser_type")
    case browser_type
    when :chromium
      Capybara.current_session.driver
              .instance_variable_get("@browser")
              .instance_variable_get("@playwright_browser")
              .contexts.first
              .grant_permissions(%w[clipboard-read clipboard-write])
    end
    form = find_by_testid_starting_with(SearchForm::FullTextComponent.testid_prefix)
    within form do
      fill_in "Regular expression", with: "foo\\s+bar"
      click_on "Search"
    end
  end

  it "allows users to copy the value" do
    expect(page).to have_text(/foo\s+bar/)

    target_card = find_by_testid_starting_with(Sentence::CardComponent.testid_prefix)
    within target_card do
      click_button "UUID"
      clip_text_component = find_by_testid_starting_with(Shared::ClipTextComponent.testid_prefix, visible: :visible)
      within clip_text_component do
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
