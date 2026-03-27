# frozen_string_literal: true

class Article::DropdownActionComponentPreview < ViewComponent::Preview
  def default
    article = Article.first
    render Article::DropdownActionComponent.new(article)
  end
end
