# displays site_name.
class SitesController < ApplicationController
  def index
    @sites = Article.group(:site_name).order(count_all: :desc).count.to_a
    @sites.map! { |site| { name: site[0], count: site[1] } }
  end

  def show
    @site_name = params[:site_name]
    @article_count = Article.where(site_name: @site_name).count
    @sentence_count = Sentence.joins(:article).where(article: { site_name: @site_name }).count
  end
end
