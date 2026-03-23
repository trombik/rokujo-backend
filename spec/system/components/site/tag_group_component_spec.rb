require "rails_helper"

RSpec.describe Site::TagGroupComponent, :js, type: :system do
  let!(:tag) { create(:collection_tag) }
  let(:preview_name) { "default" }
  let(:preview_path) do
    component_path = described_class.name.underscore.sub("_component", "")
    "#{lookbook.lookbook_preview_path(component_path)}/#{preview_name}"
  end

  before do
    # create ArticleCollection to tag
    article = create(:article)
    create(:article_collection, value: article.site_name)
  end

  it "renders in preview" do
    visit preview_path

    # the component is shown
    expect(page).to have_component(described_class)

    # and the tag is not shown
    expect(page).to have_no_text(tag.name)
    click_button class: "dropdown-toggle"
    expect(page).to have_unchecked_field(tag.name)
    check tag.name

    expect do
      click_on "submit"
      # the component is replaced by turbo_stream and the tag is shown
      expect(page).to have_text(tag.name)
    end.to change(ArticleCollectionTagging, :count).by(1)
  end
end
