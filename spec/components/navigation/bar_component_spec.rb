# frozen_string_literal: true

require "rails_helper"

RSpec.describe Navigation::BarComponent, type: :component do
  let(:component) { described_class.new }

  it "does not raise" do
    expect { render_inline component }.not_to raise_error
  end
end
