# frozen_string_literal: true

require "rails_helper"

RSpec.describe Collocations::VerbWithNounComponent, type: :component do
  describe ".new" do
    it "does not raise" do
      expect { described_class.new("noun", {}) }.not_to raise_error
    end
  end
end
