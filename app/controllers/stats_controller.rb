# A controller to route request for stats.
class StatsController < ApplicationController
  layout false

  def total_articles
    render Stats::TotalArticlesComponent.new(Article.count)
  end
end
