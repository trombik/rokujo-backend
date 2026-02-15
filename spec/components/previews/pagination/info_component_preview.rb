# frozen_string_literal: true

require "pagy/console"

class Pagination::InfoComponentPreview < ViewComponent::Preview
  include Pagy::Method

  def default
    page, _sentences = pagy(:countish, Sentence.all, items: 20)
    render(Pagination::InfoComponent.new(page))
  end
end
