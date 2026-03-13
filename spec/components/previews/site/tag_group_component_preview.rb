# frozen_string_literal: true

class Site::TagGroupComponentPreview < ViewComponent::Preview
  def default
    site_name = Article.first.site_name
    collection = ArticleCollection.find_by(key: "site_name", value: site_name)
    render Site::TagGroupComponent.new(site_name: site_name, collection: collection)
  end
end
