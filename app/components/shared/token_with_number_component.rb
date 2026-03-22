# frozen_string_literal: true

# a bordered token with number
class Shared::TokenWithNumberComponent < ViewComponent::Base
  def initialize(text: "", number: 0)
    @text = text
    @number = number
    super()
  end

  def render?
    content_or_text.present?
  end

  private

  attr_reader :number, :text

  def div_class
    "btn btn-sm border-1 border-light-subtle bg-light py-0 px-1 mx-1"
  end

  def content_or_text
    content || text
  end
end
