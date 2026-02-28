# Senteces in Articles.
class Sentence < ApplicationRecord
  belongs_to :article, foreign_key: "article_uuid", primary_key: "uuid", inverse_of: :sentences
  has_many :token_analyses, foreign_key: [:article_uuid, :line_number],
                            primary_key: [:article_uuid, :line_number],
                            inverse_of: :sentence,
                            dependent: :destroy

  validates :text, presence: true
  validates :line_number, presence: true

  scope :like, ->(word) { where("text LIKE ?", "%#{word}%") }
  scope :match, ->(pattern) { where("text regexp ?", pattern) }
  scope :context_sentences, lambda { |target, limit = 3|
    where(article: target.article.id)
      .where(line_number: (target.line_number - limit)..(target.line_number + limit))
      .order(:line_number)
  }

  def self.analysis_ratio
    all = Sentence.count
    with_token_analysis = Sentence.joins(:token_analyses).distinct.count
    all.zero? ? 0 : (with_token_analysis / all.to_f)
  end

  def self.tokens_per_sentence
    all = Sentence.count
    tokens = TokenAnalysis.count
    all.zero? ? 0 : (tokens / all)
  end

  # Search word from Sentence with search operators
  def self.search_with_operators(word, operators)
    joins(:article)
      .includes(:article)
      .merge(Article.site_names_like(operators[:site_names]))
      .merge(Article.urls_like(operators[:urls]))
      .match(word)
  end

  def self.find_sentences_with_particle_and_verb(noun, particle, verb)
    joins(:token_analyses)
      .where(token_analyses: { text: noun })
      .joins("INNER JOIN token_analyses AS particles
                ON token_analyses.token_id = particles.head
               AND token_analyses.article_uuid = particles.article_uuid
               AND token_analyses.line_number = particles.line_number")
      .where(particles: { text: particle })
      .joins("INNER JOIN token_analyses AS verbs
               ON token_analyses.head = verbs.token_id
              AND particles.article_uuid = verbs.article_uuid
              AND particles.line_number = verbs.line_number")
      .where(verbs: { lemma: verb })
      .select("sentences.*, token_analyses.token_id AS noun_id, \
                particles.token_id AS particle_id, \
                verbs.token_id AS verb_id")
      .distinct
  end

  # rubocop:disable Metrics/AbcSize
  def analyze_and_store_pos!
    token_analyses.delete_all
    analysis_results = TextAnalysisService.call(text)
    return unless analysis_results

    token_data = analysis_results.map do |t|
      {
        article_uuid: article_uuid,
        line_number: line_number,
        token_id: t["i"],
        text: t["text"],
        lemma: t["lemma"],
        pos: t["pos"],
        tag: t["tag"],
        head: t["head"],
        morph: t["morph"],
        start: t["idx"],
        end: t["idx"] + t["text"].size,
        dep: t["dep"]
      }
    end
    TokenAnalysis.import token_data, validate: true
  end
  # rubocop:enable Metrics/AbcSize
end
