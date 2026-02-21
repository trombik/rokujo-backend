# frozen_string_literal: true

# A controller that manage background jobs
class TokenAnalysis::ManagerComponent < ViewComponent::Base
  attr_reader :n_sentences, :n_sentences_without_tokens, :jobs_in_queue

  def initialize(n_sentences:, n_sentences_without_tokens:, jobs_in_queue:)
    @n_sentences_without_tokens = n_sentences_without_tokens
    @n_sentences = n_sentences
    @jobs_in_queue = jobs_in_queue
    super()
  end

  def inprogress?
    jobs_in_queue.positive?
  end

  def button_state_start
    inprogress? ? "disabled" : ""
  end

  def button_state_stop
    inprogress? ? "" : "disabled"
  end

  def percent_of_sentences_without_tokens
    percent = n_sentences_without_tokens / n_sentences.to_f * 100
    percent.round(1)
  end
end
