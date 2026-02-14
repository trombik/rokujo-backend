# frozen_string_literal: true

class Sentence::CardComponentPreview < ViewComponent::Preview
  def default
    article = Article.first
    sentence = article.sentences.first
    word = sentence.text[1..2]
    render(Sentence::CardComponent.new(sentence, word))
  end
end
