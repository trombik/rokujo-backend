require "rails_helper"

RSpec.describe ArticleCollectionTagging, type: :model do
  describe "association" do
    it { is_expected.to belong_to(:article_collection) }
    it { is_expected.to belong_to(:collection_tag) }
  end
end
