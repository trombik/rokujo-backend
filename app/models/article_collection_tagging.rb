# A bridge model between ArticleCollection and CollectionTag
class ArticleCollectionTagging < ApplicationRecord
  belongs_to :article_collection
  belongs_to :collection_tag
end
