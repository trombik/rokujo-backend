# frozen_string_literal: true

require "pagy/console"

class Pagination::NaviComponentPreview < ViewComponent::Preview
  include Pagy::Method

  def default
    page, _sentences = pagy(:countish, Sentence.all, items: 20)
    render(Pagination::NaviComponent.new(page))
  end
end
