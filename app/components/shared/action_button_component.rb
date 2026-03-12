# frozen_string_literal: true

# A button to fire an event
class Shared::ActionButtonComponent < ViewComponent::Base
  def initialize(icon: "copy", text: nil, **options)
    @icon = icon
    @text = text
    @options = options
    super()
  end

  attr_reader :text, :icon, :options
end
