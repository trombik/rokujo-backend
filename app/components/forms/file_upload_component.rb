# frozen_string_literal: true

# Form to upload files to import
class Forms::FileUploadComponent < ViewComponent::Base
  include Concerns::IdentifiableComponent

  def button_component
    ButtonComponent.new
  end

  private

  def field_class
    "form-control #{invalid_class}"
  end

  def invalid_class
    invalid? ? "is-invalid" : ""
  end

  def invalid?
    flash[:alert].present?
  end

  def uniq_key
    "no_uniq"
  end

  # button to open the modal.
  class ButtonComponent < ViewComponent::Base
    erb_template <<~ERB
      <%= button_to "Upload file", upload_files_new_path, method: :get, class: "btn btn-primary", data: { turbo_stream: true, testid: testid } %>
    ERB

    include Concerns::IdentifiableComponent
  end
end
