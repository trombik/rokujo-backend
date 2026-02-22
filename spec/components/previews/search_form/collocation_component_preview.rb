# frozen_string_literal: true

class SearchForm::CollocationComponentPreview < ViewComponent::Preview
  def default
    render(SearchForm::CollocationComponent.new)
  end
end
