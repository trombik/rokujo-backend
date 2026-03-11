# frozen_string_literal: true

class Row::SiteComponentPreview < ViewComponent::Preview
  def default
    site_name = Article.first.site_name
    count = 123
    collection = ArticleCollection.find_by(key: "site_name", value: site_name)

    render Row::SiteComponent.new(site: { name: site_name, count: count, collection: collection })
  end
end
