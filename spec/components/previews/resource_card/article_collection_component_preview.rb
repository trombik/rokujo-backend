# frozen_string_literal: true

class ResourceCard::ArticleCollectionComponentPreview < ViewComponent::Preview
  def default
    factory = FactoryBot.build(:article_collection, name: "News",
                                                    key: "site_name",
                                                    value: "My News")
    article_collection = ArticleCollection.first || factory
    render ResourceCard::ArticleCollectionComponent.new(article_collection)
  end
end
