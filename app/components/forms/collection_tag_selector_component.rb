# frozen_string_literal: true

# A form to add tags to ArticleCollection
class Forms::CollectionTagSelectorComponent < ViewComponent::Base
  include Concerns::IdentifiableComponent

  attr_reader :article_collection

  def initialize(article_collection)
    @article_collection = article_collection
    super()
  end

  def render?
    article_collection.present?
  end

  def all_tags
    CollectionTag.all
  end

  def uniq_key
    article_collection.id
  end
end
