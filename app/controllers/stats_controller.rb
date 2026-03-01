# A controller to route request for stats.
class StatsController < ApplicationController
  layout :choose_layout

  def index
    respond_to :html
  end

  def total_articles
    count = Article.count
    respond_to :html, :turbo_stream
    render Stats::TotalArticlesComponent.new(count)
  end

  def total_sentences
    count = Sentence.count
    respond_to :html, :turbo_stream
    render Stats::TotalSentencesComponent.new(count)
  end

  def total_token_analyses
    count = TokenAnalysis.count
    respond_to :html, :turbo_stream
    render Stats::TotalTokenAnalysesComponent.new(count)
  end

  def sentence_analysis_ratio
    percentage = Sentence.analysis_ratio * 100
    respond_to :html, :turbo_stream
    render Stats::SentenceAnalysisRatioComponent.new(percentage)
  end

  def sentences_per_article
    count = Article.sentences_per_article
    respond_to :html, :turbo_stream
    render Stats::SentencesPerArticleComponent.new(count)
  end

  def tokens_per_sentence
    count = Sentence.tokens_per_sentence
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

  private

  def choose_layout
    return "empty" if action_name == "index"

    false
  end
end
