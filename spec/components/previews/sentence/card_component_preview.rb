# frozen_string_literal: true

class Sentence::CardComponentPreview < ViewComponent::Preview
  def default
    article = Article.first
    sentence = article.sentences.first
    word = sentence.text[1..2]
    render(Sentence::CardComponent.new(sentence, word))
  end

  def without_title_and_site_name
    article = Article.first
    article.title = ""
    article.site_name = ""
    sentence = article.sentences.first
    word = sentence.text[1..2]
    render(Sentence::CardComponent.new(sentence, word))
  end
end
