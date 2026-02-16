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

  # rubocop:disable Metrics/AbcSize
  def analyze_and_store_pos!(model)
    doc = model.read(text)
    token_analyses.delete_all
    token_data = doc.map do |token|
      {
        article_uuid: article_uuid,
        line_number: line_number,
        token_id: token.i,
        text: token.text,
        lemma: token.lemma,
        pos: token.pos,
        tag: token.tag,
        head: token.head.i,
        morph: token.morph.to_s,
        start: token.idx,
        end: token.idx + token.text.size,
        dep: token.dep
      }
    end
    TokenAnalysis.import token_data, validate: true
  end
  # rubocop:enable Metrics/AbcSize
end
