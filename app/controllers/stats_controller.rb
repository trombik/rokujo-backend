# A controller to route request for stats.
class StatsController < ApplicationController
  layout :choose_layout
  before_action :set_site_name

  def index
    respond_to :html
  end

  def total_articles
    count = Article.by_site_name(@site_name).count
    respond_to :html, :turbo_stream
    render Stats::TotalArticlesComponent.new(count)
  end

  def total_sentences
    count = Sentence.by_site_name(@site_name).count
    respond_to :html, :turbo_stream
    render Stats::TotalSentencesComponent.new(count)
  end

  def total_token_analyses
    count = Article.joins(sentences: :token_analyses).by_site_name(@site_name).count
    respond_to :html, :turbo_stream
    render Stats::TotalTokenAnalysesComponent.new(count)
  end

  def sentence_analysis_ratio
    scope = Sentence.by_site_name(@site_name)
    percentage = Sentence.analysis_ratio(scope) * 100
    respond_to :html, :turbo_stream
    render Stats::SentenceAnalysisRatioComponent.new(percentage)
  end

  def sentences_per_article
    scope = Article.by_site_name(@site_name)
    count = Article.sentences_per_article(scope)
    respond_to :html, :turbo_stream
    render Stats::SentencesPerArticleComponent.new(count)
  end

  def tokens_per_sentence
    scope = Sentence.by_site_name(@site_name)
    count = Sentence.tokens_per_sentence(scope)
    respond_to :html, :turbo_stream
    render Stats::TokensPerSentenceComponent.new(count)
  end

  def articles_by_site_name
    data = Article.count_by_site_name
    total = Article.count
    respond_to :html, :turbo_stream
    render Stats::ArticlesBySitenameComponent.new(data, total: total)
  end

  def sentences_by_site_name
    data = Sentence.count_by_site_name
    total = Sentence.count
    respond_to :html, :turbo_stream
    render Stats::SentencesBySitenameComponent.new(data, total: total)
  end

  def articles_without_sentence
    data = Article.with_sentence_less_than_or_equal(0).to_a.count
    respond_to :html, :turbo_stream
    render Stats::ArticlesWithoutSentenceComponent.new(data)
  end

  private

  def set_site_name
    @site_name = params[:site_name]
  end

  def choose_layout
    return "application" if action_name == "index"

    false
  end
end
