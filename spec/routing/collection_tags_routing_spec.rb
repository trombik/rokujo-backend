require "rails_helper"

RSpec.describe CollectionTagsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/collection_tags").to route_to("collection_tags#index")
    end

    it "routes to #new" do
      expect(get: "/collection_tags/new").to route_to("collection_tags#new")
    end

    it "routes to #show" do
      expect(get: "/collection_tags/1").to route_to("collection_tags#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/collection_tags/1/edit").to route_to("collection_tags#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/collection_tags").to route_to("collection_tags#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/collection_tags/1").to route_to("collection_tags#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/collection_tags/1").to route_to("collection_tags#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/collection_tags/1").to route_to("collection_tags#destroy", id: "1")
    end
  end
end
