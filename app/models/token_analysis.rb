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

  # Find adjectives that have the noun as their head (for adjective modifiers)
  scope :with_modifiers_noun_as_head, lambda {
    joins("LEFT JOIN \
          token_analyses AS modifiers ON token_analyses.token_id = modifiers.head \
          AND token_analyses.article_uuid = modifiers.article_uuid \
          AND token_analyses.line_number = modifiers.line_number")
      .where(heads: { pos: "NOUN" })
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
      .with_modifiers_noun_as_head
      # Filter by modifier tag (e.g., starts with "形容詞")
      .where("modifiers.tag LIKE ?", "形容詞%")
      # Group by modifier text and noun lemma
      .group("modifiers.text", "heads.lemma")
      .order(count_all: :desc)
      .count
  end
end
