# frozen_string_literal: true

class Row::ArticleComponentPreview < ViewComponent::Preview
  def default
    article = Article.first
    render Row::ArticleComponent.new(article: article)
  end

  def without_site_name
    article = FactoryBot.build(:article,
                               title: "Article without site_name",
                               url: "http://example.org/site",
                               normalized_url: "example.org/path",
                               site_name: nil)
    render Row::ArticleComponent.new(article: article)
  end
end
