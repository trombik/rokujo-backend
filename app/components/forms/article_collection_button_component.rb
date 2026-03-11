# frozen_string_literal: true

# A button to create ArticleCollection with pre-defined attributes.
class Forms::ArticleCollectionButtonComponent < ViewComponent::Base
  # @param article_collection [ArticleCollection] an ArticleCollection with
  #   pre-defined attributes.
  def initialize(article_collection)
    @article_collection = article_collection
    super()
  end

  attr_reader :article_collection

  def render?
    return false if article_collection.name.blank?

    ArticleCollection.where(key: key, value: value).none?
  end

  def id
    "#{self.class.name.gsub("::", "_").underscore}_#{key}_#{value}"
  end

  delegate :key, to: :article_collection
  delegate :value, to: :article_collection
  delegate :name, to: :article_collection
end
