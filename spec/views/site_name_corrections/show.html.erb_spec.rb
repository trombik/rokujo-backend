require "rails_helper"

RSpec.describe "site_name_corrections/show", type: :view do
  before do
    assign(:site_name_correction, SiteNameCorrection.create!(
                                    domain: "Domain",
                                    name: "Name"
                                  ))
  end

  it "renders attributes in <p>", :aggregate_failures do
    render
    expect(rendered).to match(/Domain/)
    expect(rendered).to match(/Name/)
  end
end
