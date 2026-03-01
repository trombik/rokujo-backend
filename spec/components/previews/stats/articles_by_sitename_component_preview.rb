# frozen_string_literal: true

class Stats::ArticlesBySitenameComponentPreview < ViewComponent::Preview
  def default
    data = {
      "foo" => 10_000,
      "bar" => 10
    }
    total = 10_010
    render Stats::ArticlesBySitenameComponent.new(data, total: total)
  end

  def frame
    render Stats::ArticlesBySitenameComponent.new
  end
end
