# Query object to extract linguistic modifiers for specific target tokens.
#
# A "modifier" provides additional information about another word (the "head").
# In technical translation, identifying these modifiers is crucial for defining
# the specific properties of a term (e.g., "Static" in "Static IP").
#
# ### Key Dependency Types (deps):
# - +nmod+ (Noun Modifier): A noun modifying another noun, typically via "の" in Japanese.
#   (e.g., "Rails' environment" -> "Rails" --nmod--> "environment")
# - +compound+ (Compound): Words that combine to form a single multi-word expression.
#   (e.g., "Config file" -> "Config" --compound--> "file")
# - +amod+ (Adjectival Modifier): An adjective describing a noun's quality.
#   (e.g., "Static IP" -> "Static" --amod--> "IP")
#
# @example
#   targets = TokenAnalysis.where(pos: "NOUN")
#   # Extract modifiers that refine the meaning of the target nouns
#   query = ModifierQuery.new(targets, deps: ["nmod", "compound", "amod"])
#   modifiers = query.call
#
class ModifierQuery
  # @param targets_scope [ActiveRecord::Relation] A scope of TokenAnalysis serving as the "heads" (targets).
  # @param deps [Array<String>] A list of dependency types to filter (e.g., ["nmod", "compound"]).
  def initialize(targets_scope, deps:)
    @targets_scope = targets_scope
    @deps = deps
  end

  # Executes the query to find linguistic modifiers.
  #
  # @return [ActiveRecord::Relation] A relation of TokenAnalysis records that act as modifiers.
  # @note This method implements two critical linguistic constraints for Japanese:
  #   1. Positional Constraint: Modifiers MUST precede the head (token_id < targets.token_id).
  #   2. Exclusion of Coordination: "conj" (conjunctions) are excluded because they represent
  #      parallel items (A and B) rather than a modification relationship (A's B).
  def call
    # 1. Internal join to retrieve tokens within the same document and line as the targets.
    targets_sql = @targets_scope.to_sql

    TokenAnalysis
      .joins("INNER JOIN (#{targets_sql}) AS targets ON
              token_analyses.article_uuid = targets.article_uuid AND
              token_analyses.line_number = targets.line_number")
      # Filter by specified dependency types (e.g., nmod, compound, amod).
      .where(token_analyses: { dep: @deps })
      # Ensure the modifier's head pointer matches the target's unique ID.
      .where("token_analyses.head = targets.token_id")
      # 2. Japanese Linguistic Constraint: Modifiers always appear before the word they modify.
      .where("token_analyses.token_id < targets.token_id")
      # 3. Structural Constraint: Parallel relationships (conj) are not modifiers.
      .where.not(token_analyses: { dep: "conj" })
  end
end
