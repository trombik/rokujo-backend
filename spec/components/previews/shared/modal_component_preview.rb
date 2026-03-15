# frozen_string_literal: true

class Shared::ModalComponentPreview < ViewComponent::Preview
  def default
    render(Shared::ModalComponent.new)
  end
end
