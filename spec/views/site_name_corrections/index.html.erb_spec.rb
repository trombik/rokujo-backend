require "rails_helper"

RSpec.describe "site_name_corrections/index", type: :view do
  before do
    assign(:site_name_corrections, create_list(:site_name_correction, 2))
  end

  it "renders a list of site_name_corrections" do
    render
    cell_selector = "div>p"
    assert_select cell_selector, text: Regexp.new("Show this site name correction"), count: 2
  end
end
