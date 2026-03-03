# frozen_string_literal: true

# A badge for ArticleCollection
class Article::CollectionBadgeComponent < ViewComponent::Base
  attr_reader :collection

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
      align_items: "center"
    }.map { |k, v| "#{k.to_s.dasherize}: #{v}" }.join("; ")
  end

  def color_hex
    seed = Digest::MD5.hexdigest(@collection.name).to_i(16)
    color_name = BASE_COLORS[seed % BASE_COLORS.size]
    color_values(color_name, from: 400, to: 600).first
  end
end
