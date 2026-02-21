# frozen_string_literal: true

class TokenAnalysis::ManagerComponentPreview < ViewComponent::Preview
  def default
    render TokenAnalysis::ManagerComponent.new(
      n_sentences_without_tokens: Sentence.where.missing(:token_analyses).size,
      n_sentences: Sentence.all.size,
      jobs_in_queue: SolidQueue::Job.scheduled.size
    )
  end
end
