require "rails_helper"

RSpec.describe "collection_tags/new", type: :view do
  before do
    assign(:collection_tag, CollectionTag.new(
                              name: "MyString"
                            ))
  end

  it "renders new collection_tag form" do
    render

    assert_select "form[action=?][method=?]", collection_tags_path, "post" do
      assert_select "input[name=?]", "collection_tag[name]"
    end
  end
end
