# Senteces in Articles.
class Sentence < ApplicationRecord
  belongs_to :article, foreign_key: "article_uuid", primary_key: "uuid", inverse_of: :sentences

  validates :text, presence: true
  validates :line_number, presence: true

  scope :like, ->(word) { where("text LIKE ?", "%#{word}%") }
  scope :match, ->(pattern) { where("text regexp ?", pattern) }
  scope :context_sentences, lambda { |target, limit = 3|
    where(article: target.article.id)
      .where(line_number: (target.line_number - limit)..(target.line_number + limit))
      .order(:line_number)
  }
end
