require "rails_helper"

RSpec.describe SiteNameCorrectionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/site_name_corrections").to route_to("site_name_corrections#index")
    end

    it "routes to #new" do
      expect(get: "/site_name_corrections/new").to route_to("site_name_corrections#new")
    end

    it "routes to #show" do
      expect(get: "/site_name_corrections/1").to route_to("site_name_corrections#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/site_name_corrections/1/edit").to route_to("site_name_corrections#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/site_name_corrections").to route_to("site_name_corrections#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/site_name_corrections/1").to route_to("site_name_corrections#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/site_name_corrections/1").to route_to("site_name_corrections#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/site_name_corrections/1").to route_to("site_name_corrections#destroy", id: "1")
    end
  end
end
