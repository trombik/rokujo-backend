# frozen_string_literal: true

# A component to show a sentence in an article with context.
class Article::ContextComponent < ViewComponent::Base
  attr_reader :target_sentence, :context_sentences

  def initialize(target, contexts)
    @target_sentence = target
    @context_sentences = contexts
    super()
  end
end
