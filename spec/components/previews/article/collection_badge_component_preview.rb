# frozen_string_literal: true

class Article::CollectionBadgeComponentPreview < ViewComponent::Preview
  # @!group
  def default
    collection = FactoryBot.build(:article_collection, name: "Default")
    render Article::CollectionBadgeComponent.new(collection)
  end

  def foo
    collection = FactoryBot.build(:article_collection, name: "foo")
    render Article::CollectionBadgeComponent.new(collection)
  end

  def random
    collection = FactoryBot.build(:article_collection, name: "Random #{rand 100}")
    render Article::CollectionBadgeComponent.new(collection)
  end

  def japanese
    collection = FactoryBot.build(:article_collection, name: "日本語")
    render Article::CollectionBadgeComponent.new(collection)
  end

  def english
    collection = FactoryBot.build(:article_collection, name: "English")
    render Article::CollectionBadgeComponent.new(collection)
  end
  # @!endgroup
end
