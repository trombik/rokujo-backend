# frozen_string_literal: true

class Forms::CollectArticlesComponentPreview < ViewComponent::Preview
  def default
    spider_name = "read-more"
    render Forms::CollectArticlesComponent.for(spider_name)
  end

  def sitemap
    spider_name = "sitemap"
    render Forms::CollectArticlesComponent.for(spider_name)
  end
end
