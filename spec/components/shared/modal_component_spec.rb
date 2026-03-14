# frozen_string_literal: true

require "rails_helper"

RSpec.describe Shared::ModalComponent, type: :component do
  let(:component) { described_class.new }

  before do
    render_inline component
  end

  it "generates non-uniq id" do
    another_component = component

    expect(component.id).to eq another_component.id
  end

  it "has correect modal structure" do
    expect(page).to have_css("div.modal > div.modal-dialog")
  end
end
