# frozen_string_literal: true

class Forms::ArticleCollectionComponentPreview < ViewComponent::Preview
  def default
    article_collection = nil
    render Forms::ArticleCollectionComponent.new(article_collection)
  end

  def with_name
    article_collection = ArticleCollection.new(key: "site_name", value: "foo")
    render Forms::ArticleCollectionComponent.new(article_collection)
  end
end
