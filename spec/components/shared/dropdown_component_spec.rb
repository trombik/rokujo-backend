# frozen_string_literal: true

require "rails_helper"

RSpec.describe Shared::DropdownComponent, type: :component do
  let(:items) do
    [
      { text: "link0", link: "#0" },
      { text: "link1", link: "#1" },
      { text: "link2", link: "#2", disabled: true }
    ]
  end
  let(:component) { described_class.new }

  before do
    render_inline component do |c|
      c.with_dropdown_button(text: "Action")
      items.each do |link|
        c.with_dropdown_item(**link)
      end
    end
  end

  it "renders the component" do
    expect(page).to have_component(component.class)
  end

  it "has a dropdown button" do
    within find_component(component.class, match: :first) do
      expect(page).to have_component(component.class::DropdownButtonComponent, count: 1)
    end
  end

  it "has dropdown items" do
    within find_component(component.class, match: :first) do
      expect(page).to have_component(component.class::DropdownItemComponent, count: items.size)
    end
  end

  it "renders enabled and disabled items with correct aria-disabled values" do
    within find_component(component.class, match: :first) do
      items.each do |item|
        expect(page).to have_css("a[aria-disabled='#{item[:disabled] ? "true" : "false"}']", text: item[:text])
      end
    end
  end

  it "renders disabled items with correct class name" do
    within find_component(component.class, match: :first) do
      items.each do |item|
        expect(page).to have_link(item[:text],
                                  href: item[:link],
                                  class: item[:disabled] ? "disabled" : nil)
      end
    end
  end

  context "when expanded is false (the default)" do
    specify "the menu is not shown" do
      within find_component(component.class, match: :first) do
        expect(page).to have_button("Action", aria: { expanded: false }).and have_no_css(".dropdown-menu.show")
      end
    end
  end

  context "when expanded is true" do
    let(:component) { described_class.new(expanded: true) }

    specify "the menu is shown" do
      within find_component(component.class, match: :first) do
        expect(page).to have_button("Action", aria: { expanded: true }).and have_css(".dropdown-menu.show")
      end
    end
  end
end
