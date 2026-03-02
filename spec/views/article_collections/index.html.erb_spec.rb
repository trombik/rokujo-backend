require "rails_helper"

RSpec.describe "article_collections/index", type: :view do
  before do
    assign(:article_collections, [
             ArticleCollection.create!(
               name: "foo",
               key: "site_name",
               value: "value1"
             ),
             ArticleCollection.create!(
               name: "bar",
               key: "site_name",
               value: "value2"
             )
           ])
    render
  end

  it "renders a list of article_collections" do
    expect(rendered).to have_content("foo").and have_content("bar")
  end
end
