require "rails_helper"

RSpec.describe "article_collections/edit", type: :view do
  let(:article_collection) do
    ArticleCollection.create!(
      name: "MyString",
      key: "MyString"
    )
  end

  before do
    assign(:article_collection, article_collection)
  end

  it "renders the edit article_collection form" do
    render

    assert_select "form[action=?][method=?]", article_collection_path(article_collection), "post" do
      assert_select "input[name=?]", "article_collection[name]"

      assert_select "input[name=?]", "article_collection[key]"
    end
  end
end
