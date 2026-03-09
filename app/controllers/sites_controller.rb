# displays site_name.
class SitesController < ApplicationController
  def index
    @sites = Article.group(:site_name).order(count_all: :desc).count.to_a
    @sites.map! { |site| { name: site[0], count: site[1] } }
  end

  def show
    @site_name = params[:site_name]
  end

  def total_articles
    @site_name = params[:site_name]
    count = Article.by_site_name(@site_name).count
    respond_to :html, :turbo_stream
    render Stats::TotalArticlesComponent.new(count)
  end

  def total_sentences
    @site_name = params[:site_name]
    count = Sentence.by_site_name(@site_name).count
    respond_to :html, :turbo_stream
    render Stats::TotalSentencesComponent.new(count)
  end

  def total_token_analyses
    @site_name = params[:site_name]
    count = Article.joins(sentences: :token_analyses).where(site_name: @site_name).count
    render Stats::TotalTokenAnalysesComponent.new(count)
  end
end
