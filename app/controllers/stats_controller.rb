# A controller to route request for stats.
class StatsController < ApplicationController
  layout "empty"

  def total_articles
    render Stats::TotalArticlesComponent.new(Article.count)
  end

  def total_sentences
    render Stats::TotalSentencesComponent.new(Sentence.count)
  end

  def total_token_analyses
    render Stats::TotalTokenAnalysesComponent.new(TokenAnalysis.count)
  end

  def sentence_analysis_ratio
    percentage = Sentence.analysis_ratio * 100
    render Stats::SentenceAnalysisRatioComponent.new(percentage)
  end

  def sentences_per_article
    render Stats::SentencesPerArticleComponent.new(Article.sentences_per_article)
  end

  def tokens_per_sentence
    render Stats::TokensPerSentenceComponent.new(Sentence.tokens_per_sentence)
  end
end
