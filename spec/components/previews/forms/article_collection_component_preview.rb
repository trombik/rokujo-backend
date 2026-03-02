# frozen_string_literal: true

class Forms::ArticleCollectionComponentPreview < ViewComponent::Preview
  def default
    article_collection = FactoryBot.build(:article_collection)
    render Forms::ArticleCollectionComponent.new(article_collection)
  end
end
