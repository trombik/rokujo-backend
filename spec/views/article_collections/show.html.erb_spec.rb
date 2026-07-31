require "rails_helper"

RSpec.describe "article_collections/show", type: :view do
  before do
    assign(:article_collection, ArticleCollection.create!(
                                  name: "Foo",
                                  key: "site_name",
                                  value: "Value"
                                ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to include("Foo").and include("site_name")
  end
end
