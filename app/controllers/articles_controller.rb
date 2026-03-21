# A controller for Articles
class ArticlesController < ApplicationController
  def index
    site_name = params[:site_name]
    @pagy, @articles = pagy(:countish,
                            Article.by_site_name(site_name),
                            items: 20)
    @n_articles_without_site_name = Article.without_site_name.count
  end

  # Shows an article by uuid.
  def show
    @article = Article.find_by(uuid: params[:uuid])
    render_not_found and return unless @article
  end

  # Shows a sentence in an article with context around the sentence.
  def context
    @article = Article.find_by(uuid: params[:uuid])
    render_not_found and return unless @article

    line_number = params[:line_number].to_i
    @target_sentence = @article.sentences.find_by(line_number: line_number)
    render_not_found and return unless @target_sentence

    @context_sentences = Sentence.context_sentences(@target_sentence)
  end

  def without_site_name
    @pagy, @articles_without_site_name = pagy(:countish,
                                              Article.without_site_name.order(:normalized_url),
                                              items: 20)
  end
end
