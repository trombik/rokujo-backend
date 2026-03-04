# frozen_string_literal: true

# A form to add tags to ArticleCollection
class Forms::CollectionTagSelectorComponent < ViewComponent::Base
  attr_reader :article_collection

  def initialize(article_collection)
    @article_collection = article_collection
    super()
  end

  def all_tags
    CollectionTag.all
  end

  def id
    "#{self.class.name.underscore.gsub("/", "_")}-#{article_collection.id}"
  end
end
