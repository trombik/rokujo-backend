# Senteces in Articles.
class Sentence < ApplicationRecord
  belongs_to :article, foreign_key: "article_uuid", primary_key: "uuid", inverse_of: :sentences

  validates :text, presence: true
  validates :line_number, presence: true
end
