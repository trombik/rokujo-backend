# frozen_string_literal: true

# Row for sites.
class Row::SiteComponent < ViewComponent::Base
  def initialize(site:)
    @site = site
    @name = site[:name]
    @count = site[:count]
    @collection = site[:collection]
    super()
  end

  attr_reader :site, :name, :count, :collection

  def render?
    name.present?
  end

  def id
    hash = Digest::MD5.hexdigest(@name)
    "#{self.class.name.gsub("::", "_").underscore}_#{hash}"
  end

  private

  def new_collection
    ArticleCollection.new(name: name, key: "site_name", value: name)
  end
end
