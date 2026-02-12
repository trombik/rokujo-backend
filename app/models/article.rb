require "pp"

# Article is a series of sentences extracted from files and web pages.
class Article < ApplicationRecord
  self.primary_key = "uuid"
  has_many :sentences, foreign_key: "article_uuid", primary_key: "uuid", dependent: :destroy, inverse_of: :article
  has_many :article_sources, dependent: :destroy
  has_many :sources, through: :article_sources, source: :source_article, inverse_of: :referenced_articles

  has_many :reversed_article_sources, class_name: "ArticleSource", foreign_key: :source_article_id,
                                      dependent: :destroy, inverse_of: :source_article
  has_many :referenced_articles, through: :reversed_article_sources, source: :article, inverse_of: :sources

  validates :uuid, presence: true, uniqueness: true

  def replace_sentences_with_hash(new_sentences)
    sentences.delete_all
    return if new_sentences.blank?

    transformed_sentences = new_sentences.map do |s|
      Sentence.build(text: s[:text], line_number: s.dig(:meta, :line_number))
    end
    self.sentences = transformed_sentences
  end

  def replace_sources_from_hash(new_sources)
    sources.delete_all
    return if new_sources.blank?

    transformed_sources = new_sources.map { |source| Article.import_from_hash!(source) }
    self.sources = transformed_sources
  end

  # rubocop:disable Metrics/MethodLength
  def self.import_from_hash!(hash)
    transaction do
      h = hash.deep_symbolize_keys
      article = Article.find_or_initialize_by(uuid: h[:uuid])
      article.assign_attributes(hash.symbolize_keys.except(:sentences, :sources))
      article.replace_sentences_with_hash(h[:sentences])
      article.replace_sources_from_hash(h[:sources])
      article.save!
      article
    rescue StandardError => e
      raise e, "#{e.message}\nHash Content:\n#{PP.pp(hash, "")}"
    end
  end
  # rubocop:enable Metrics/MethodLength
end
