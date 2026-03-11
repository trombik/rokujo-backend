# frozen_string_literal: true

class Forms::ArticleCollectionButtonComponentPreview < ViewComponent::Preview
  def default
    article_collection = ArticleCollection.new(name: "Foo", key: "site_name", value: "foobarbuz")
    render Forms::ArticleCollectionButtonComponent.new(article_collection)
  end
end
