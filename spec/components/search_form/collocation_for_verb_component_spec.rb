# frozen_string_literal: true

require "rails_helper"

RSpec.describe SearchForm::CollocationForVerbComponent, type: :component do
  let(:component) { described_class.new }

  before do
    render_inline component
  end

  it "renders the component" do
    expect(page).to have_component(described_class)
  end
end
