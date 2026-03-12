# frozen_string_literal: true

class Shared::ClipTextComponentPreview < ViewComponent::Preview
  def default
    text = "http://example.org//very/very/long/path/to/resource"
    render Shared::ClipTextComponent.new(text: NormalizeUrlService.call(text))
  end
end
