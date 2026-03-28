# Reconstructs a meaningful phrase (linguistic "chunk") from a given root token.
#
# This class traverses the dependency tree to collect descendant tokens while
# applying specific filters to prevent the phrase from becoming too specific
# or context-heavy (e.g., stripping away relative clauses or unrelated verbs).
#
# ### Key Mechanisms:
# - **STOP_DEPS**: Prunes branches that represent separate clauses or lists
#   (e.g., +acl+ to remove descriptive verb phrases).
# - **Parent POS Filtering**: Stops traversal if the parent is a noun, unless
#   the current token is a functional word (ADP, AUX, PART).
#
# @example
#   modifier = sentence.token_analyses.find_by(text: "Static")
#   all_tokens = sentence.token_analyses
#   # Returns "Static IP" instead of the whole sentence.
#   phrase = PhraseReconstructor.call(modifier, all_tokens)
#
class PhraseReconstructor
  # Dependency types that should trigger an immediate stop to avoid over-expansion.
  # - +advcl+ / +acl+: Prevents inclusion of full clauses (e.g., "The server [that I measured]").
  # - +conj+ / +punct+: Prevents jumping to parallel items or through punctuation.
  # - +obl+: Excludes oblique nominals (prepositional/postpositional phrases acting as adjuncts).
  STOP_DEPS = %w[advcl advmod punct conj obl acl].freeze

  # Part-of-speech tags that act as boundaries.
  # We generally stop at nouns to avoid capturing subsequent unrelated modifiers.
  STOP_POS = %w[NOUN PROPN PRON].freeze

  # Reconstructs the phrase string from a starting token.
  #
  # @param modifier [TokenAnalysis] The starting token for subtree discovery.
  # @param sentence_tokens [Array<TokenAnalysis>] All tokens in the current sentence.
  # @return [String] The concatenated text of the identified phrase.
  def self.call(modifier, sentence_tokens)
    return "" if modifier.nil?

    subtree_ids = find_descendant_ids(modifier, sentence_tokens)

    sentence_tokens
      .select { |t| subtree_ids.include?(t.token_id) }
      .sort_by(&:token_id)
      .map(&:text)
      .join
  end

  # Recursively (up to 10 levels) finds all descendant token IDs in the dependency tree.
  #
  # @param root_token [TokenAnalysis] The root of the traversal.
  # @param tokens [Array<TokenAnalysis>] Available tokens to search.
  # @return [Set<Integer>] A set of token_ids belonging to the phrase.
  def self.find_descendant_ids(root_token, tokens)
    descendants = [root_token.token_id].to_set

    # Depth limit to prevent infinite loops and maintain performance.
    10.times do
      new_descendants = tokens.select do |t|
        # 1. Structural check: Is this token a child of our current set?
        descendants.include?(t.head) &&
          descendants.exclude?(t.token_id) &&
          # 2. Dependency check: Is this branch too semantically distant?
          STOP_DEPS.exclude?(t.dep.to_s.downcase) &&
          # 3. POS check: Should we stop based on the parent's attribute?
          !should_stop_at_parent?(t, tokens, descendants)
      end

      break if new_descendants.empty?

      descendants.merge(new_descendants.map(&:token_id))
    end

    descendants
  end

  # Determines if the traversal should stop based on the parent's Part-of-Speech.
  #
  # This logic allows functional words (like particles "の" or auxiliaries) to be
  # included even if the parent is a noun, while blocking more "content-heavy" children.
  #
  # @param token [TokenAnalysis] The current token being evaluated.
  # @param tokens [Array<TokenAnalysis>] The full list of tokens for lookup.
  # @param _descendants [Set<Integer>] (Unused) Current set of found IDs.
  # @return [Boolean] True if the traversal should stop here.
  def self.should_stop_at_parent?(token, tokens, _descendants)
    parent = tokens.find { |pt| pt.token_id == token.head }
    return false unless parent

    # If the parent is a noun, only allow functional/auxiliary children (ADP, AUX, PART).
    # This keeps "A of B" together but separates "A [measured by] B".
    return !%w[ADP AUX PART].include?(token.pos.to_s.upcase) if STOP_POS.include?(parent.pos.to_s.upcase)

    false
  end
end
