# frozen_string_literal: true

require "rails_helper"

RSpec.describe Shared::ModalFormComponent, type: :component do
  let(:component) { described_class.new }

  before do
    render_inline component do |c|
      c.with_title { "Title" }
      c.with_body { "Body" }
      c.with_submit_button { "OK" }
    end
  end

  it "renders the component" do
    expect(page).to have_component described_class
  end

  it "renders given blocks" do
    expect(page).to have_content("Title").and have_content("Body").and have_content("OK")
  end
end
