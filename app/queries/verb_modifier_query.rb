# A query to group modifers that qualifies a verb.
class VerbModifierQuery
  DEPS = %w[
    advmod
    advcl
    obl
    obj
  ].freeze

  POS = %w[
    ADP
    SCONJ
  ].freeze

  def initialize(targets_scope)
    @targets_scope = targets_scope
  end

  def call
    targets_sql = @targets_scope.to_sql

    TokenAnalysis
      .joins("INNER JOIN (#{targets_sql}) AS targets ON
              token_analyses.article_uuid = targets.article_uuid AND
              token_analyses.line_number = targets.line_number")
      # capture ADP and SCONJ that points to the token
      .joins("LEFT JOIN token_analyses AS particles ON
              particles.article_uuid = token_analyses.article_uuid AND
              particles.line_number = token_analyses.line_number")
      .where("particles.head = token_analyses.token_id)")
      .where("particles.pos", in: POS)
      .where(token_analyses: { dep: DEPS })
      .where("token_analyses.head = targets.token_id")
      .where("token_analyses.token_id < targets.token_id")
      # joins the token and its ADP and SCONJ (if any)
      .group("token_analyses.lemma || COALESCE(particles.text, '')")
      .order(count_all: :desc)
      .count
  end
end
