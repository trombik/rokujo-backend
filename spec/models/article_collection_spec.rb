require "rails_helper"

RSpec.describe ArticleCollection, type: :model do
  describe "validation" do
    it { is_expected.to validate_presence_of :key }
    it { is_expected.to validate_presence_of :name }
  end

  describe "assertion" do
    it { is_expected.to have_many :articles }
    it { is_expected.to have_many :article_collection_taggings }
    it { is_expected.to have_many :collection_tags }
  end
end
