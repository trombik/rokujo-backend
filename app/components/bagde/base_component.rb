# frozen_string_literal: true

# the base class for badges
class Bagde::BaseComponent < ViewComponent::Base
  attr_reader :resource

  include ColorPalletGeneratorHelper

  BASE_COLORS = %w[
    blue indigo violet purple fuchsia pink rose
    red orange amber emerald teal cyan sky
  ].freeze

  def initialize(resource)
    @resource = resource
    super()
  end

  def link_path
    return "#" unless resource&.persisted?

    polymorphic_path(resource)
  end

  def icon_name
    "exclamation-circle"
  end

  def call
    link_to link_path, class: "badge rounded-pill text-decoration-none shadow-sm",
                       style: badge_style do
                         concat(tag.i(class: "bi bi-#{icon_name} me-1"))
                         concat(resource.name)
                       end
  end

  def render?
    resource.present?
  end

  private

  def color_hex
    seed = Digest::MD5.hexdigest(resource.name).to_i(16)
    color_name = BASE_COLORS[seed % BASE_COLORS.size]
    color_values(color_name, from: 400, to: 600).first
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
end
