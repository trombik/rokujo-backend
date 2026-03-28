# Orchestrates the extraction of noun phrases containing a specific lemma.
#
# This service identifies target nouns by lemma, finds their linguistic modifiers
# using {ModifierQuery}, and reconstructs the full phrases using {PhraseReconstructor}.
# It is optimized for performance by batch-loading tokens and using hash-based lookups.
#
# ### Workflow:
# 1. Identify "Target" tokens matching the given lemma.
# 2. Find "Modifier" tokens that point to those targets via specified dependencies (+nmod+, +compound+).
# 3. Batch-load all tokens for the affected lines to avoid N+1 queries.
# 4. Reconstruct and count unique phrases.
#
# @example
#   extractor = NounPhraseExtractor.new(lemma: "サーバー")
#   # Returns {"移行サーバー"=>10, "本番サーバー"=>5, ...}
#   results = extractor.call { |phrase| puts "Found: #{phrase}" }
#
class NounPhraseExtractor
  # @param lemma [String] The dictionary form of the target noun (e.g., "サーバー").
  # @param deps [Array<String>] Dependency types to consider for modification.
  def initialize(lemma:, deps: %w[nmod compound])
    @lemma = lemma
    @deps = deps
    # Retrieve target tokens and their potential modifiers via Query objects.
    @targets = TargetNounQuery.new(lemma: @lemma).call
    @modifiers = ModifierQuery.new(@targets, deps: @deps).call
  end

  # Executes the extraction process and returns a frequency map of phrases.
  #
  # @yield [String] Yields each reconstructed phrase as it is found.
  # @return [Hash<String, Integer>] A hash of phrases and their occurrence counts, sorted by frequency.
  def call
    counts = Hash.new(0)

    # Phrase Reconstruction Loop
    # We iterate through identified modifiers to build complete linguistic units.
    modifiers.each do |mod|
      # RATIONALE: ModifierQuery might return tokens that modify a different word
      # in the same line if the dependency tree is complex. We must verify that
      # the current modifier's head is EXACTLY one of our target lemmas to ensure
      # the phrase is relevant to the user's query.
      next unless target?(mod.article_uuid, mod.line_number, mod.head)

      # RATIONALE: PhraseReconstructor requires a contiguous, ordered array of tokens
      # to correctly identify adjacent adjuncts (like "の" or "な") and to resolve
      # the physical string in the correct reading order.
      line_tokens = find_sorted_tokens_by(mod)
      next unless line_tokens

      # RECONSTRUCTION: Starting from the modifier (e.g., "Static"), we crawl down
      # to find all related sub-tokens, resulting in a full phrase (e.g., "Static IP").
      phrase = PhraseReconstructor.call(mod, line_tokens)

      # RATIONALE: Yielding each phrase as it is found allows the caller to
      # perform real-time actions (e.g., progress logging, streaming UI updates)
      # without waiting for the entire batch to complete.
      counts[phrase] += 1
      yield phrase if block_given?
    end

    # Return results sorted by frequency (descending).
    counts.sort_by { |_, count| -count }.to_h
  end

  private

  attr_reader :targets, :modifiers

  def find_sorted_tokens_by(mod)
    all_related_tokens[[mod.article_uuid, mod.line_number]]&.sort_by(&:token_id)
  end

  def target?(article_uuid, line_number, token_id)
    target_registry.key?([article_uuid, line_number, token_id])
  end

  # Optimization: Convert targets into a Hash for O(1) lookup during the refinement stage.
  def target_registry
    @target_registry ||= targets.to_h do |target|
      [[target.article_uuid, target.line_number, target.token_id], true]
    end
  end

  # Returns all tokens in the relevant lines, grouped by their coordinates.
  def all_related_tokens
    return @all_related_tokens if @all_related_tokens

    # Performance Optimization: Identify unique line coordinates and batch-load all tokens.
    # This prevents the "N+1 problem" when reconstructing phrases for multiple lines.
    coords = modifiers.map { |m| [m.article_uuid, m.line_number] }.uniq
    all_tokens_raw = []

    # Process in slices of 100 to stay within SQL parameter limits.
    coords.each_slice(100) do |batch|
      # NOTE: This performs a broad fetch of all tokens in the relevant lines.
      all_tokens_raw += TokenAnalysis.where([:article_uuid, :line_number] => batch).to_a
    end

    # Group raw tokens by line for efficient access during iteration.
    @all_related_tokens = all_tokens_raw.group_by { |t| [t.article_uuid, t.line_number] }
  end
end
