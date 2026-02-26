require "rails_helper"

RSpec.describe "site_name_corrections/new", type: :view do
  before do
    assign(:site_name_correction, SiteNameCorrection.new(
                                    domain: "MyString",
                                    name: "MyString"
                                  ))
  end

  it "renders new site_name_correction form" do
    render

    assert_select "form[action=?][method=?]", site_name_corrections_path, "post" do
      assert_select "input[name=?]", "site_name_correction[domain]"

      assert_select "input[name=?]", "site_name_correction[name]"
    end
  end
end
