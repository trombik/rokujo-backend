# frozen_string_literal: true

class Forms::FileUploadComponentPreview < ViewComponent::Preview
  def default
    render Forms::FileUploadComponent.new.button_component
  end
end
