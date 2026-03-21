require "capybara/dsl"

# custome matchers for component and system
module CustomMatchers
  def find_by_testid(id, ...)
    page.find("[data-testid='#{id}']", ...)
  end

  def have_testid(id)
    have_css("[data-testid='#{id}']")
  end

  def have_no_testid(id)
    have_no_css("[data-testid='#{id}']")
  end

  def find_by_testid_starting_with(id, ...)
    page.find("[data-testid^='#{id}']", ...)
  end

  def have_testid_starting_with(id, ...)
    have_css("[data-testid^='#{id}']", ...)
  end

  def have_no_testid_starting_with(id, ...)
    have_no_css("[data-testid^='#{id}']", ...)
  end

  def find_component(component, ...)
    find_by_testid_starting_with(component.testid_prefix, ...)
  end

  def have_component(component, ...)
    have_testid_starting_with(component.testid_prefix, ...)
  end

  def have_no_component(component, ...)
    have_no_testid_starting_with(component.testid_prefix, ...)
  end
end

headless = ENV["HEADFULL"].nil?
Capybara.register_driver(:playwright_chromium) do |app|
  Capybara::Playwright::Driver.new(app,
                                   browser_type: :chromium,
                                   browser_options: {},
                                   headless: headless)
end

Capybara.register_driver(:playwright_firefox) do |app|
  Capybara::Playwright::Driver.new(app,
                                   browser_type: :firefox,
                                   browser_options: {},
                                   headless: headless)
end

Capybara.default_max_wait_time = 15

# Normalizes whitespaces when using `has_text?` and similar matchers
Capybara.default_normalize_ws = true

# Where to store artifacts (e.g. screenshots, downloaded files, etc.)
Capybara.save_path = ENV.fetch("CAPYBARA_ARTIFACTS", "./tmp/capybara")

Capybara.default_driver = :rack_test
Capybara.javascript_driver = ENV["CI"] ? :playwright_chromium : :playwright_firefox

Capybara.configure do |config|
  config.test_id = "data-testid"
end

RSpec.configure do |config|
  config.prepend_before(:each, type: :system) do |example|
    driven_by Capybara.default_driver unless example.metadata[:js]
  end
  config.prepend_before(:each, :js, type: :system) do
    driven_by Capybara.javascript_driver
  end
  config.include CustomMatchers, type: :system
  config.include CustomMatchers, type: :component
end
