# frozen_string_literal: true

class Article::ContextComponentPreview < ViewComponent::Preview
  def default
    sentence = Sentence.first
    render(Article::ContextComponent.new(sentence, Sentence.context_sentences(sentence)))
  end
end
