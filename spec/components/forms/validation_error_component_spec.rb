# frozen_string_literal: true

require "rails_helper"

RSpec.describe Forms::ValidationErrorComponent, type: :component do
  let(:resource) do
    resource = build(:site_name_correction, name: nil)
    resource.save
    resource
  end

  let(:component) { described_class.new(resource) }

  before do
    render_inline component
  end

  it "renders validation error" do
    expect(page).to have_component(described_class)
  end
end
