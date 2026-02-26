# frozen_string_literal: true

require "rails_helper"

RSpec.describe IconComponent, type: :component do
  let(:icon_set_name) { "bi" }
  let(:name) { "arrow-right" }
  let(:icon) { described_class.new(name) }

  before do
    render_inline icon
  end

  it "has the base class name for the icon set" do
    expect(page).to have_css("i.#{icon_set_name}")
  end

  it "has the class name for the icon" do
    expect(page).to have_css("i.#{icon_set_name}-#{name}")
  end

  context "when optional klass is given" do
    let(:icon) { described_class.new(name, klass: "foo") }

    it "includes the klass in the class attribute" do
      expect(page).to have_css("i.foo")
    end
  end
end
