# frozen_string_literal: true

class Text::RubyComponentPreview < ViewComponent::Preview
  def default
    render Text::RubyComponent.new("注釈", "ちゅうしゃく")
  end
end
