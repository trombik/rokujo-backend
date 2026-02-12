require "rails_helper"

RSpec.describe ArticleSource, type: :model do
  describe "association" do
    it { is_expected.to belong_to :article }
    it { is_expected.to belong_to :source_article }
  end

  context "when an article is assigned to another article as a source" do
    subject(:parent) { create(:article, uuid: "uuid1", url: "url1") }

    let(:source) { create(:article, uuid: "source_uuid", url: "source_url") }
    let(:another_source) { create(:article, uuid: "another_source_uuid", url: "another_source_url") }

    before do
      parent.sources << source
      parent.sources << another_source
    end

    it "has sources" do
      expect(parent.sources.order(:id)).to contain_exactly(source, another_source)
    end

    specify "source is referenced by parent" do
      expect(source.referenced_articles.first).to eq parent
    end

    specify "another_source is referenced by parent" do
      expect(another_source.referenced_articles.first).to eq parent
    end
  end
end
