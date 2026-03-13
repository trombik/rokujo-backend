# frozen_string_literal: true

# Renders collection badges and collection tags. When the site has no article
# collections, it renders a button to create one based on the site_name on the
# fly.
class Site::TagGroupComponent < ViewComponent::Base
  include Concerns::IdentifiableComponent

  def initialize(site_name:, collection: [])
    @site_name = site_name
    @collection = collection
    super()
  end

  attr_reader :site_name, :collection

  def uniq_key
    Digest::MD5.hexdigest(@site_name)
  end
end
