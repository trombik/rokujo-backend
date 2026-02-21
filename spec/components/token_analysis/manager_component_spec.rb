# frozen_string_literal: true

require "rails_helper"

RSpec.describe TokenAnalysis::ManagerComponent, type: :component do
  describe "#inprogress" do
    it "returns true when jobs_in_queue is positive" do
      component = described_class.new(n_sentences: 10, n_sentences_without_tokens: 1, jobs_in_queue: 3)
      expect(component.inprogress?).to be true
    end

    it "returns false when jobs_in_queue is zero" do
      component = described_class.new(n_sentences: 10, n_sentences_without_tokens: 1, jobs_in_queue: 0)
      expect(component.inprogress?).to be false
    end
  end
end
