require "rails_helper"

RSpec.describe "site_name_corrections/edit", type: :view do
  let(:site_name_correction) do
    SiteNameCorrection.create!(
      domain: "MyString",
      name: "MyString"
    )
  end

  before do
    assign(:site_name_correction, site_name_correction)
  end

  it "renders the edit site_name_correction form" do
    render

    assert_select "form[action=?][method=?]", site_name_correction_path(site_name_correction), "post" do
      assert_select "input[name=?]", "site_name_correction[domain]"

      assert_select "input[name=?]", "site_name_correction[name]"
    end
  end
end
