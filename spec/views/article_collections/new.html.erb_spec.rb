require "rails_helper"

RSpec.describe "article_collections/new", type: :view do
  before do
    assign(:article_collection, ArticleCollection.new(
                                  name: "MyString",
                                  key: "MyString"
                                ))
  end

  it "renders new article_collection form" do
    render

    assert_select "form[action=?][method=?]", article_collections_path, "post" do
      assert_select "input[name=?]", "article_collection[name]"

      assert_select "input[name=?]", "article_collection[key]"
    end
  end
end
