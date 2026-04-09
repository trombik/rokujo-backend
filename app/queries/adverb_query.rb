# Adverb query
class AdverbQuery
  def initialize(targets_scope)
    @targets_scope = targets_scope
  end

  def call
    targets_sql = @targets_scope.to_sql

    TokenAnalysis
      .joins("INNER JOIN (#{targets_sql}) AS targets ON
              token_analyses.article_uuid = targets.article_uuid AND
              token_analyses.line_number = targets.line_number")
      .where(token_analyses: { dep: %w[advcl] })
      .where("token_analyses.head = targets.token_id")
  end
end
