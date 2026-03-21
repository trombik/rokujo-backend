# frozen_string_literal: true

class Shared::TokenWithNumberComponentPreview < ViewComponent::Preview
  def default
    render Shared::TokenWithNumberComponent.new(text: "単語", number: 123)
  end
end
