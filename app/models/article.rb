# Article is a series of sentences extracted from files and web pages.
class Article < ApplicationRecord
  self.primary_key = "uuid"
  has_many :sentences, foreign_key: "article_uuid", primary_key: "uuid", dependent: :destroy, inverse_of: :article

  validates :sentences, length: { minimum: 1 }
  validates :uuid, presence: true, uniqueness: true

  def self.import_from_hash!(hash)
    transaction do
      article = Article.find_or_initialize_by(uuid: hash["uuid"])
      article.assign_attributes(hash.symbolize_keys.except(:sentences, :sources))
      article.sentences.delete_all
      article.sentences = hash["sentences"].map do |s|
        article.sentences.build(text: s["text"], line_number: s.dig("meta", "line_number"))
      end
      article.save!
    end
  end
end
