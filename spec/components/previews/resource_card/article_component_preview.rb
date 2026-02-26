# frozen_string_literal: true

class ResourceCard::ArticleComponentPreview < ViewComponent::Preview
  def default
    article = Article.joins(:sources).distinct.first
    render ResourceCard::ArticleComponent.new(article)
  end
end
