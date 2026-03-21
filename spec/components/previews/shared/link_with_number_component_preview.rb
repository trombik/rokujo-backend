# frozen_string_literal: true

class Shared::LinkWithNumberComponentPreview < ViewComponent::Preview
  def default
    link = "#"
    render Shared::LinkWithNumberComponent.new(link, text: "単語", number: 123)
  end
end
