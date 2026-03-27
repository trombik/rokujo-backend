# frozen_string_literal: true

class Shared::ModalFormComponentPreview < ViewComponent::Preview
  def default
    render Shared::ModalFormComponent.new do |c|
      c.with_title { "Title" }
      c.with_body { "Body" }
      c.with_submit_button do
        tag.button "OK", class: "btn btn-primary"
      end
    end
  end
end
