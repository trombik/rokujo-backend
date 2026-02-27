require "rails_helper"

RSpec.describe "collection_tags/edit", type: :view do
  let(:collection_tag) do
    CollectionTag.create!(
      name: "MyString"
    )
  end

  before do
    assign(:collection_tag, collection_tag)
  end

  it "renders the edit collection_tag form" do
    render

    assert_select "form[action=?][method=?]", collection_tag_path(collection_tag), "post" do
      assert_select "input[name=?]", "collection_tag[name]"
    end
  end
end
