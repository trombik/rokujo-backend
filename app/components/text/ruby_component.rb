# frozen_string_literal: true

# Annotate a text with ruby
class Text::RubyComponent < ViewComponent::Base
  attr_reader :text, :ruby

  def initialize(text, ruby)
    super()
    @text = text
    @ruby = ruby
  end
end
