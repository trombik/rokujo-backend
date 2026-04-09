# Verb version of NounPhraseExtractor
class VerbModifierExtractor
  USEFUL_POS = %w[ADV ADJ].freeze
  USEFUL_DEPS = %w[advmod advcl obl].freeze

  def initialize(lemma:)
    @lemma = lemma
    @targets = TargetVerbQuery.new(lemma: @lemma).call
    @modifiers = ModifierQuery.new(@targets, deps: USEFUL_DEPS)
                              .call
                              .where(pos: USEFUL_POS)
  end

  def call
    counts = Hash.new(0)

    modifiers.each do |mod|
      next unless target?(mod.article_uuid, mod.line_number, mod.head)

      line_tokens = find_sorted_tokens_by(mod)
      next unless line_tokens

      phrase = PhraseReconstructor.call(mod, line_tokens)
      counts[phrase] += 1
      yield phrase if block_given?
    end

    counts.sort_by { |_, count| -count }.to_h
  end

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
