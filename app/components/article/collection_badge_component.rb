# frozen_string_literal: true

# A badge for ArticleCollection
class Article::CollectionBadgeComponent < ViewComponent::Base
  attr_reader :collection

  include Concerns::IdentifiableComponent
  include ColorPalletGeneratorHelper

  BASE_COLORS = %w[
    blue indigo violet purple fuchsia pink rose
    red orange amber emerald teal cyan sky
  ].freeze

  def initialize(collection)
    @collection = collection
    super()
  end

  def render?
    collection.present?
  end

  private

  def path
    collection.persisted? ? article_collection_path(collection) : "#"
  end

  def badge_style
    {
      background_color: color_hex,
      color: "#fff",
      font_size: "0.9rem",
      padding: "0.5em 1em",
      font_weight: "500",
      display: "inline-flex",
      height: "fit-content",
      align_items: "center"
    }.map { |k, v| "#{k.to_s.dasherize}: #{v}" }.join("; ")
  end

  def color_hex
    color_values("slate", number: 400).first
  end

  def uniq_key
    collection&.id || super
  end
end
