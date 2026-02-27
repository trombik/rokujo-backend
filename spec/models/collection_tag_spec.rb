require "rails_helper"

RSpec.describe CollectionTag, type: :model do
  describe "assertion" do
    it { is_expected.to have_many :article_collections }
    it { is_expected.to have_many :article_collection_taggings }
  end

  describe "validation" do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_uniqueness_of :name }
  end
end
