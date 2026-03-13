# frozen_string_literal: true

# components to display a text and an icon to copy the value
class Shared::ClipTextComponent < ViewComponent::Base
  include Concerns::IdentifiableComponent

  def initialize(text:, max_width: "400px")
    @text = text
    @max_width = max_width
    super()
  end

  attr_reader :text, :max_width
end
