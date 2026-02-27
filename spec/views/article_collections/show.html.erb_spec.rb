require "rails_helper"

RSpec.describe "article_collections/show", type: :view do
  before do
    assign(:article_collection, ArticleCollection.create!(
                                  name: "Foo",
                                  key: "domain"
                                ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Foo/).and match(/domain/)
  end
end
