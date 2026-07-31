require "rails_helper"

RSpec.describe "collection_tags/index", type: :view do
  before do
    assign(:collection_tags, [
             CollectionTag.create!(
               name: "foo"
             ),
             CollectionTag.create!(
               name: "bar"
             )
           ])
    render
  end

  it "renders a list of collection_tags" do
    expect(rendered).to have_text("foo").and have_text("bar")
  end
end
