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

  scope :by_site_name, ->(site_name) { site_name.present? ? joins(:article).where(article: { site_name: site_name }) : all }

  def self.count_by_site_name(limit: 10)
    joins(:article).group(article: :site_name).limit(limit).order(count_all: :desc).count
  end

  def self.analysis_ratio(scope = all)
    total_count = scope.count
    return 0 if total_count.zero?

    total_token_analysis = scope.joins(:token_analyses).distinct.count
    total_token_analysis / total_count.to_f
  end

  def self.tokens_per_sentence(scope = all)
    total_sentence = scope.count
    return 0 if total_sentence.zero?

    total_token = TokenAnalysis.joins(:sentence).merge(scope).count
    total_token / total_sentence.to_f
  end

  # Search word from Sentence with search operators
  def self.search_with_operators(word, operators)
    query = joins(:article).includes(:article)

    query = if operators[:tags].present?
              # When any tags are given, ignore other operators.
              apply_tag_filters(query, operators[:tags])
            else
              # Otherwise, filter articles with AND-ed operators
              query.merge(Article.site_names_like(operators[:site_names]))
                   .merge(Article.urls_like(operators[:urls]))
            end

    query.match(word).distinct
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

  # Apply tag-based filters by merging Article criteria into the Sentence query.
  #
  # This method prioritizes tags over individual operators by converting
  # collection metadata (site_name, normalized_url) into a combined OR-clause.
  #
  # @param query [ActiveRecord::Relation] The current Sentence query scope.
  # @param tag_names [Array<String>] List of tag names to filter by.
  #
  # @return [ActiveRecord::Relation]
  #   The updated query merged with Article conditions, or a NullRelation if
  #   no criteria are found.
  #
  # @example
  #   apply_tag_filters(Sentence.all, ["Ruby"])
  #   # => Generates: ... WHERE articles.site_name = 'Ruby Official' OR articles.normalized_url LIKE 'ruby-lang.org%'
  def self.apply_tag_filters(query, tag_names)
    criteria = Article.criteria_from_tags(tag_names)
    return query.none if criteria.empty?

    scope = Article.where(site_name: criteria["site_name"])

    criteria["normalized_url"].each do |url|
      scope = scope.or(Article.where("normalized_url LIKE ?", "#{ArticleCollection.sanitize_sql_like(url)}%"))
    end

    query.merge(scope)
  end

  private_class_method :apply_tag_filters
end
