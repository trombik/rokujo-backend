require "rails_helper"

RSpec.describe "collection_tags/show", type: :view do
  before do
    assign(:collection_tag, CollectionTag.create!(
                              name: "Name"
                            ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
