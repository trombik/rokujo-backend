require "rails_helper"

RSpec.describe "ArticleCollections", type: :request do
  let(:article_collection) { create(:article_collection) }
  let(:ruby_tag) { create(:collection_tag, name: "Ruby") }
  let(:rails_tag) { create(:collection_tag, name: "Rails") }
  let(:params) do
    {
      article_collection: {
        collection_tag_ids: [ruby_tag.id, rails_tag.id],
        key: article_collection.key,
        value: article_collection.value
      }
    }
  end

  describe "PATCH /article_collections/:id" do
    context "with valid params" do
      before do
        patch article_collection_path(article_collection), params: params
        article_collection.reload
      end

      it "updates the collection and redirects" do
        expect(article_collection.collection_tag_ids).to contain_exactly(ruby_tag.id, rails_tag.id)
      end

      it "redirects with :see_other" do
        expect(response).to redirect_to(article_collection_path(article_collection))
      end
    end

    context "when selecting no tags" do
      let(:params) do
        {
          article_collection: { collection_tag_ids: [""] }
        }
      end

      it "clears all tags" do
        article_collection.collection_tags << ruby_tag
        patch article_collection_path(article_collection), params: params
        article_collection.reload

        expect(article_collection.collection_tags).to be_empty
      end
    end
  end
end
