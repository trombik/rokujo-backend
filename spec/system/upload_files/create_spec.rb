require "rails_helper"

RSpec.describe "Upload and import files", :js, type: :system do
  it "accepts uploaded file and enqueue ImportArticleJob" do
    visit collect_articles_path

    file_upload_class = Forms::FileUploadComponent
    button_class = file_upload_class.new.button_component.class
    expect(page).to have_component(button_class)
    click_on "Upload file"
    expect(page).to have_component(file_upload_class)
    page.attach_file("Files", Rails.root.join("spec/fixtures/files/test.jsonl"))

    expect do
      click_on "Upload"
      expect(page).to have_component(Notification::ToastComponent)
    end.to have_enqueued_job(ImportFileJob)
  end
end
