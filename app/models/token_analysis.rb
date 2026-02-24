# TokenAnalysis class
class TokenAnalysis < ApplicationRecord
  belongs_to :sentence,
             foreign_key: [:article_uuid, :line_number],
             primary_key: [:article_uuid, :line_number],
             inverse_of: :token_analyses

  # Find the head token that the current token points to
  scope :with_article, lambda {
    joins("INNER JOIN \
          token_analyses AS heads ON token_analyses.head = heads.token_id \
          AND token_analyses.article_uuid = heads.article_uuid \
          AND token_analyses.line_number = heads.line_number")
  }

  # Find particles that have the noun as their head (for verb collocations)
  scope :with_particles_noun_as_head, lambda {
    joins("LEFT JOIN \
          token_analyses AS particles ON token_analyses.token_id = particles.head \
          AND token_analyses.article_uuid = particles.article_uuid \
          AND token_analyses.line_number = particles.line_number")
      .where(heads: { pos: "VERB" })
  }

  def self.find_verb_collocations_by_noun(noun)
    where(text: noun, pos: "NOUN")
      .with_article
      .with_particles_noun_as_head
      # Filter by particle tag (e.g., starts with "助詞", but not "副助詞")
      .where("particles.tag LIKE ?", "助詞%")
      .where("particles.tag NOT LIKE ?", "%副助詞%")
      # Group by particle text and verb lemma
      .group("particles.text", "heads.lemma")
      .order(count_all: :desc)
      .count
  end

  def self.find_adjective_modifiers_by_noun(noun)
    where(text: noun, pos: "NOUN")
      .with_article
      .joins("LEFT JOIN \
          token_analyses AS modifiers ON token_analyses.token_id = modifiers.head \
          AND token_analyses.article_uuid = modifiers.article_uuid \
          AND token_analyses.line_number = modifiers.line_number")
      .where(heads: { pos: "NOUN", text: noun })
      .where(modifiers: { pos: "ADJ" })
      # Group by modifier text and noun lemma
      .group("modifiers.text", "heads.lemma")
      .order(count_all: :desc)
      .count
  end

  def self.find_modifier_patterns_for(noun, by: nil)
    target_deps = by || %w[nmod acl compound amod nummod appos]

    query = <<~SQL.squish
      SELECT
        (
          SELECT GROUP_CONCAT(text, '')
          FROM token_analyses AS sub
          WHERE sub.article_uuid = token_analyses.article_uuid
            AND sub.line_number = token_analyses.line_number
            AND sub.token_id >= token_analyses.token_id
            AND sub.token_id < token_analyses.head
        ) AS phrase,
        COUNT(*) AS count
      FROM token_analyses
      INNER JOIN token_analyses AS targets ON
        token_analyses.article_uuid = targets.article_uuid AND
        token_analyses.line_number  = targets.line_number AND
        token_analyses.head         = targets.token_id
      WHERE targets.lemma = :noun
        AND targets.pos = 'NOUN'
        AND token_analyses.start < targets.start
        AND token_analyses.dep IN (:deps)
        AND (targets.token_id - token_analyses.token_id) < 6
      GROUP BY phrase
      ORDER BY count DESC
    SQL

    from("(#{sanitize_sql_array([query, { noun: noun, deps: target_deps }])}) AS results")
      .select("results.phrase, results.count")
  end
end
