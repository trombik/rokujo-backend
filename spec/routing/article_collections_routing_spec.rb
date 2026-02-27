require "rails_helper"

RSpec.describe ArticleCollectionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/article_collections").to route_to("article_collections#index")
    end

    it "routes to #new" do
      expect(get: "/article_collections/new").to route_to("article_collections#new")
    end

    it "routes to #show" do
      expect(get: "/article_collections/1").to route_to("article_collections#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/article_collections/1/edit").to route_to("article_collections#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/article_collections").to route_to("article_collections#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/article_collections/1").to route_to("article_collections#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/article_collections/1").to route_to("article_collections#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/article_collections/1").to route_to("article_collections#destroy", id: "1")
    end
  end
end
