require "rails_helper"

RSpec.describe "UploadFiles", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get upload_files_new_path, as: :turbo_stream
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    context "with files" do
      let(:file_path) { "empty.txt" }
      let(:file) { fixture_file_upload(file_path, "text/plain") }

      it "returns success" do
        post upload_files_create_path, params: { upload: { files: [file] } }, as: :turbo_stream

        expect(response).to have_http_status(:success)
      end
    end

    context "with no files" do
      it "returns unprocessable_content" do
        post upload_files_create_path, params: { upload: { files: [] } }, as: :turbo_stream

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
